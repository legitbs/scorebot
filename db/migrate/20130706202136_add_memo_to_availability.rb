class AddMemoToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :memo, :text
  end
end
