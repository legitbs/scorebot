class AddServiceIdToFlags < ActiveRecord::Migration
  def change
    add_reference :flags, :service, index: true
  end
end
