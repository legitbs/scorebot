class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :team, index: true
      t.text :body

      t.timestamps
    end
  end
end
