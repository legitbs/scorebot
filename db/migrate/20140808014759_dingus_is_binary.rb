class DingusIsBinary < ActiveRecord::Migration
  def change
    remove_column :availabilities, :dingus
    add_column :availabilities, :dingus, :binary
  end
end
