class AddDisplayToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :display, :string
  end
end
