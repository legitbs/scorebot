class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.belongs_to :availability, index: true
      t.belongs_to :team, index: true
      t.belongs_to :flag, index: true

      t.timestamps
    end
  end
end
