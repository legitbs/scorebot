class IndexRoundAndInstanceOnScoringModels < ActiveRecord::Migration
  def change
    add_index :tokens, %i{instance_id round_id}, unique: true
    add_index :availabilities, %i{instance_id round_id}, unique: true
  end
end
