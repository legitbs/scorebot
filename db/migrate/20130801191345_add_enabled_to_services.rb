class AddEnabledToServices < ActiveRecord::Migration
  def change
    add_column :services, :enabled, :boolean
  end
end
