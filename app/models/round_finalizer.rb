class RoundFinalizer
  attr_accessor :round, :service

  def initialize(round, service)
    self.round = round
    self.service = service
  end

  def seed
    "legitbs-2014-#{round.id}"
  end

  def prng
    Random.new seed.chars.map{|c| c.ord.to_s(16)}.join.to_i(16)
  end

  def candidates
    return @candidates if defined? @candidates

    initial =  round.availabilities.failed.order(id: :asc).to_a
    initial += round.expiring_tokens.order(id: :asc).to_a
    generator = prng
    @candidates = initial.sort_by{ generator.rand }
  end

  def movements
    return @movements if defined? @movements

    @movements = candidates.map do |c|
      c.process_movements

      c.as_movement_json
    end
  end

  def as_metadata_json
    { 
      seed: seed,
      sequence: candidates.map{ |c| c.as_json include_root: true, only: :id }
    }
  end
end
