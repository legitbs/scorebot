class MakeMemoColumnsBinary < ActiveRecord::Migration
  def up
    remove_column :tokens, :memo
    add_column :tokens, :memo, :binary

    remove_column :availabilities, :memo
    add_column :availabilities, :memo, :binary
  end
end
