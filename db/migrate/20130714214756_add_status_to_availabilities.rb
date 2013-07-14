class AddStatusToAvailabilities < ActiveRecord::Migration
  def change
    add_column :availabilities, :status, :integer
  end
end
