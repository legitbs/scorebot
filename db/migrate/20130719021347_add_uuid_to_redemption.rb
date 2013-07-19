class AddUuidToRedemption < ActiveRecord::Migration
  def change
    add_column :redemptions, :uuid, :uuid
  end
end
