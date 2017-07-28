class AddPortToServices < ActiveRecord::Migration[5.1]
  def change
    add_column :services, :port, :integer
  end
end
