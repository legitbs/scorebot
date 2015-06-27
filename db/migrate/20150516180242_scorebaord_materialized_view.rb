class ScorebaordMaterializedView < ActiveRecord::Migration
  def up
    Team.connection.execute <<-SQL
      CREATE MATERIALIZED VIEW scoreboards AS
      SELECT t.id as id, t.name as name, count(f.id) as score
      FROM teams as t
      left JOIN flags AS f
                ON f.team_id = t.id
      WHERE t.certname != 'legitbs'
                GROUP BY t.id, t.name
                ORDER BY
                        score desc,
                        t.name asc
      WITH DATA
    SQL

    Team.connection.execute <<-SQL
      CREATE UNIQUE INDEX ON scoreboards (id)
    SQL
  end

  def down
    Team.connection.execute "DROP TRIGGER IF EXISTS scoreboard_update_trigger ON flags"
    Team.connection.execute "DROP MATERIALIZED VIEW IF EXISTS scoreboards"
  end
end
