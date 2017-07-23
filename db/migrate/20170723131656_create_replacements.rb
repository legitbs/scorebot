class CreateReplacements < ActiveRecord::Migration[5.1]
  def change
    create_table :replacements do |t|
      t.belongs_to :team, foreign_key: true
      t.belongs_to :service, foreign_key: true
      t.belongs_to :round, foreign_key: true
      t.string :digest

      t.timestamps
    end
  end
end
