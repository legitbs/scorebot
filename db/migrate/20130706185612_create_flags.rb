class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.belongs_to :team, index: true

      t.timestamps
    end
  end
end
