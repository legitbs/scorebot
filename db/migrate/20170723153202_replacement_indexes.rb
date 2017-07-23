class ReplacementIndexes < ActiveRecord::Migration[5.1]
  def change
    add_column :replacements, :size, :integer
    add_index :replacements, :team_id
    add_index :replacements, :service_id
    add_index :replacements, :round_id
    add_index :replacements, %i{team_id service_id round_id}, unique: true
  end
end
