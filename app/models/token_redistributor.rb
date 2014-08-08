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

  private
  def process_movements_for_service(svc)
    instances = svc.instances
    recipients = instances.map(&:redemptions).flatten.map(&:team).uniq

    flags = Team.legitbs.flags.where(service: svc).to_a
    return if flags.count < recipients.count

    bounty = flags.count / recipients.count

    record = {  }

    recipients.each do |r|
      bounty.times do
        candidate = flags.pop
        candidate.update_attribute :team_id, r.id

        record[r.id] ||= []
        record[r.id] << flag.id
      end
    end

    @movement_json[svc.id] = record
  end

  def as_movement_json
    return { redistribution: @movement_json }
  end
end
