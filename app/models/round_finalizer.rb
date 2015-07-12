class RoundFinalizer
  attr_accessor :round, :service

  def initialize(round, service)
    self.round = round
    self.service = service
  end

  def seed
    "legitbs-2015-#{round.id}"
  end

  def prng
    Random.new seed.chars.map{|c| c.ord.to_s(16)}.join.to_i(16)
  end

  def service_instances
    Instance.where(service: service)
  end

  def candidates
    return @candidates if defined? @candidates

    initial =  round.availabilities.
              where(instance_id: service_instances.map(&:id)).
              failed.
              order(id: :asc).
              to_a
    initial += round.expiring_tokens.
              where(instance_id: service_instances.map(&:id)).
              order(id: :asc).
              to_a
    generator = prng
    @candidates = initial.sort_by{ generator.rand }.uniq

    @candidates << TokenRedistributor.new
  end

  def movements
    return @movements if defined? @movements

    @movements = candidates.map do |c|
      c.process_movements(round)

      c.as_movement_json
    end
  end

  def as_metadata_json
    {
      service: service.name,
      seed: seed,
      sequence: candidates.map{ |c| c.as_json include_root: true, only: :id },
      movements: movements
    }
  end
end
