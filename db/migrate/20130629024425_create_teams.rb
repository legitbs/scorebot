class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.uuid :uuid
      t.index :uuid, unique: true

      t.timestamps
    end
  end
end
