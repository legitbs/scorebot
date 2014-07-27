class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.belongs_to :availability, index: true
      t.belogns_to :team

      t.timestamps
    end
  end
end
