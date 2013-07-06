class CreateCaptures < ActiveRecord::Migration
  def change
    create_table :captures do |t|
      t.belongs_to :redemption, index: true
      t.belongs_to :flag, index: true

      t.timestamps
    end
  end
end
