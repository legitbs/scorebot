class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.belongs_to :instance, index: true
      t.belongs_to :round, index: true

      t.timestamps
    end
  end
end
