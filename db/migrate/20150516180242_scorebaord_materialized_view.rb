class ScorebaordMaterializedView < ActiveRecord::Migration
  def up
    Team.connection.execute <<-SQL
      CREATE MATERIALIZED VIEW scoreboard AS
      SELECT t.id, t.name, count(f.id) as score
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
      CREATE UNIQUE INDEX ON scoreboard (id)
    SQL

    Team.connection.execute <<-SQL
      CREATE OR REPLACE FUNCTION scoreboard_refresh_proc() RETURNS trigger AS
      $$
      BEGIN
        REFRESH MATERIALIZED VIEW CONCURRENTLY scoreboard;
      END;
      $$
      LANGUAGE plpgsql
    SQL

    Team.connection.execute <<-SQL
      CREATE TRIGGER scoreboard_update_trigger
        AFTER UPDATE ON flags
        FOR EACH STATEMENT
        EXECUTE PROCEDURE scoreboard_refresh_proc();
    SQL
  end

  def down
    Team.connection.execute "DROP TRIGGER IF EXISTS scoreboard_update_trigger ON solutions"
    Team.connection.execute "DROP FUNCTION IF EXISTS scoreboard_refresh_proc"
    Team.connection.execute "DROP MATERIALIZED VIEW IF EXISTS scoreboard"
  end
end
