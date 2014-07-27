class AddDistributionToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :distribution, :json
  end
end
