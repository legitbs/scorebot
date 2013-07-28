class Message < ActiveRecord::Base
  belongs_to :team

  def self.get_for(team, since)
    messages = where('created_at > :since and (team_id is null or team_id = :team_id)', team_id: team.id, since: Time.at(since.to_i)).
      limit(5)
    messages.map do |m|
      {
        when: m.created_at,
        who: m.team ? team.name : '>>EVERYONE<<',
        what: m.body
      }
    end
  end
end
