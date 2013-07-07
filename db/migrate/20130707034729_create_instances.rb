class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.belongs_to :team, index: true
      t.belongs_to :service, index: true

      t.timestamps
    end
  end
end
