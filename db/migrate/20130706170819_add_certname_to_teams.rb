class AddCertnameToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :certname, :string
    add_index :teams, :certname, unique: true
  end
end
