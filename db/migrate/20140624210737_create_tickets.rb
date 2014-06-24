class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.belongs_to :team, index: true
      t.text :body
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
