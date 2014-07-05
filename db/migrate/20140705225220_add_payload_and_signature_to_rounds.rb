class AddPayloadAndSignatureToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :payload, :json
    add_column :rounds, :signature, :string
  end
end
