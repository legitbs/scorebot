class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.string :key
      t.string :digest
      t.belongs_to :instance, index: true

      t.timestamps
    end
  end
end
