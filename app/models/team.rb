class Team < ActiveRecord::Base
  has_many :redemptions
  has_many :flags
  has_many :captures, through: :redemptions
  has_many :instances
  has_many :tickets
  before_create :set_uuid

  after_rollback :flush_counters
  attr_accessor :dupe_ctr_defer
  attr_accessor :other_ctr_defer

  def as_ca_json
    {
      teamname: name,
      uuid: uuid,
      certname: certname,
      joe_name: joe_name
    }
  end

  def self.legitbs
    return @@legitbs if defined?(@@legitbs) && (@@legitbs.reload rescue false)
    @@legitbs = find_by uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86"
  end

  def self.without_legitbs
    where('certname != ?', 'legitbs')
  end

  def self.for_scoreboard
    q = <<-SQL
      SELECT t.name, count(f.id) as score
      FROM teams as t
      left JOIN flags AS f 
		ON f.team_id = t.id	
      WHERE t.certname != 'legitbs'
		GROUP BY t.name
		ORDER BY 
			score desc,
			t.name asc
    SQL
    
    Stats.time('scoreboard_query'){ connection.select_all(q).map(&:symbolize_keys) }
  end

  def self.as_standings_json
    data = for_scoreboard
    
    place = 0
    prev_score = Flag.count + 1
    place_buf = 1
    { 
      standings: data.map do |r|
        score = r[:score].to_i
        if score < prev_score
          place += place_buf
          place_buf = 1
          prev_score = score
        else
          place_buf += 1
        end
        { pos: place, team: r[:name], score: 21 - place }
      end,
      generated_at: Time.now
    }
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def flush_counters
    increment! :dupe_ctr, dupe_ctr_defer if dupe_ctr_defer
    increment! :other_ctr, other_ctr_defer if other_ctr_defer
  end
end
