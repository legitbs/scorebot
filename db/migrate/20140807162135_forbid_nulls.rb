class ForbidNulls < ActiveRecord::Migration
  def change
    change_table :availabilities do |t|
      t.change :instance_id, :integer, null: false
      t.change :round_id, :integer, null: false
    end

    change_table :captures do |t|
      t.change :redemption_id, :integer, null: false
      t.change :flag_id, :integer, null: false
      t.change :round_id, :integer, null: false
    end

    change_table :flags do |t|
      t.change :team_id, :integer, null: false
      t.change :service_id, :integer, null: false
    end

    change_table :instances do |t|
      t.change :team_id, :integer, null: false
      t.change :service_id, :integer, null: false
    end

    change_table :penalties do |t|
      t.change :availability_id, :integer, null: false
      t.change :team_id, :integer, null: false
      t.change :flag_id, :integer, null: false
    end

    change_table :redemptions do |t|
      t.change :team_id, :integer, null: false
      t.change :token_id, :integer, null: false
      t.change :round_id, :integer, null: false
      t.change :uuid, :uuid, null: false, unique: true
    end

    change_table :tickets do |t|
      t.change :team_id, :integer, null: false
    end

    change_table :tokens do |t|
      t.change :instance_id, :integer, null: false
      t.change :round_id, :integer, null: false
      t.change :key, :string, unique: true, null: false
    end
  end
end
