class Scoreboard < ActiveRecord::Base
  def self.refresh!
    self.connection.execute <<-SQL
      REFRESH MATERIALIZED VIEW CONCURRENTLY scoreboard;
    SQL
  end
end
