class AddRoundToScoringModels < ActiveRecord::Migration
  def change
    add_column :tokens, :round_id, :integer
    add_column :redemptions, :round_id, :integer
    add_column :captures, :round_id, :integer
  end
end
