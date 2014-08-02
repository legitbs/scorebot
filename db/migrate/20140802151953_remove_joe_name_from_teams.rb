class RemoveJoeNameFromTeams < ActiveRecord::Migration
  def change
    change_table :teams do |t|
      t.remove :joe_name
    end
  end
end
