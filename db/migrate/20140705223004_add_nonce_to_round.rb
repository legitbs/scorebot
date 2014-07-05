class AddNonceToRound < ActiveRecord::Migration
  def change
    add_column :rounds, :nonce, :string
  end
end
