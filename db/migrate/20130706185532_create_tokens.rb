class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :key
      t.string :secret
      t.belongs_to :team, index: true
      t.belongs_to :service, index: true

      t.timestamps
    end
  end
end
