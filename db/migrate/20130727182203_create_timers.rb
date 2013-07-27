class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      t.string :name
      t.datetime :ending

      t.timestamps
    end
  end
end
