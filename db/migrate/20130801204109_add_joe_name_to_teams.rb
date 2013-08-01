class AddJoeNameToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :joe_name, :string
  end
end
