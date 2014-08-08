class TokenRedistributor
  def initialize
    @movement_json = {  }
  end

  def process_movements(round)
    @round = round

    Service.where(enabled: true).each do |svc|
      process_movements_for_service svc
    end
  end

  def as_movement_json
    return { redistribution: @movement_json }
  end

  private
  def process_movements_for_service(svc)
    instances = svc.instances
    recipients = instances.map do |i|
      i.redemptions.where(round: @round).all
    end.flatten.map(&:team).uniq

    @movement_json[svc.id] = record = {  }

    record[:instances] = instances.as_json only: :id
    record[:recipients] = recipients.as_json only: %i{ id certname }

    return if recipients.count == 0

    flags = Team.legitbs.flags.where(service: svc).to_a
    return if flags.count < recipients.count

    bounty = flags.count / recipients.count

    record[:flags] = flags.as_json only: :id
    record[:bounty] = bounty
    record[:movements] = {  }

    recipients.each do |r|
      bounty.times do
        candidate = flags.pop
        candidate.update_attribute :team_id, r.id

        record[:movements][r.id] ||= []
        record[:movements][r.id] << candidate.id
      end
    end

    @movement_json[svc.id] = record
  end
end
