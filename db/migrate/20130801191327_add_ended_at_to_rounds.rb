class AddEndedAtToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :ended_at, :datetime
  end
end
