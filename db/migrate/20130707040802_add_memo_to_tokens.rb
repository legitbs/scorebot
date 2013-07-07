class AddMemoToTokens < ActiveRecord::Migration
  def change
    add_column :tokens, :memo, :text
  end
end
