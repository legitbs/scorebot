class AddFailedCountersToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :dupe_ctr, :integer, default: 0
    add_column :teams, :old_ctr, :integer, default: 0
    add_column :teams, :notfound_ctr, :integer, default: 0
    add_column :teams, :self_ctr, :integer, default: 0
    add_column :teams, :other_ctr, :integer, default: 0
  end
end
