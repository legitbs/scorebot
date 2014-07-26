class AddDingusesToAvailabilities < ActiveRecord::Migration
  def change
    add_column :availabilities, :dingus, :string
    add_column :availabilities, :token_string, :string
    add_reference :availabilities, :token, index: true
  end
end
