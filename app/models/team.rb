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

  PARTICIPANT_COUNT = 15

  def as_ca_json
    {
      teamname: name,
      uuid: uuid,
      certname: certname
    }
  end

  def self.legitbs
    return @@legitbs if defined?(@@legitbs) && (@@legitbs.reload rescue false)
    @@legitbs = find_by id: 16
  end

  def self.without_legitbs
    where('certname != ?', 'legitbs')
  end

  def self.for_scoreboard
    q = <<-SQL
      SELECT
        t.name,
        t.id,
        count(f.id) as score,
        coalesce(t.display, t.name) as display_name
      FROM teams as t
      left JOIN flags AS f
                ON f.team_id = t.id
      WHERE t.certname != 'legitbs'
                GROUP BY t.name, t.id, display_name
                ORDER BY
                        score desc,
                        t.name asc
    SQL

    StatsD.measure('scoreboard_query'){ connection.select_all(q).map(&:symbolize_keys) }
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
        { pos: place, team: r[:name], score: (16 - place), id: r[:id], place: place }
      end,
      display_names: Hash[data.map do |r|
                                [r[:id], r[:display_name]]
                              end],
      generated_at: Time.now
    }
  end

  def scores_by_service
    q = <<-SQL
      SELECT
        service_id, count(service_id)
      FROM flags
      WHERE team_id=#{id}
      GROUP BY service_id
      ORDER BY service_id ASC
    SQL

    result = self.class.connection.select_all(q)
    Hash[result.map do |row|
      [row['service_id'].to_i, row['count'].to_i]
    end]
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
