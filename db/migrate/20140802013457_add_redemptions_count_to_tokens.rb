class AddRedemptionsCountToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :redemptions_count, :integer
  end
end
