class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
      t.belongs_to :team, index: true
      t.belongs_to :token, index: true
      t.index %i{team_id token_id}, unique: true

      t.timestamps
    end
  end
end
