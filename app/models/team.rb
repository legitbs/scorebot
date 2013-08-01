class Team < ActiveRecord::Base
  has_many :redemptions
  has_many :flags
  has_many :captures, through: :redemptions
  has_many :instances
  before_create :set_uuid

  def as_ca_json
    {
      teamname: name,
      uuid: uuid,
      certname: certname,
      joe_name: joe_name
    }
  end

  def self.legitbs
    @@legitbs ||= find_by uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86"
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
    
    connection.select_all(q).map(&:symbolize_keys)
  end

  private
  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end
end
