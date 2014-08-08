class DingusIsBinary < ActiveRecord::Migration
  def up
    remove_column :availabilities, :dingus
    add_column :availabilities, :dingus, :binary
  end
end
