require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  should have_many :instances
  should have_many :redemptions
  should have_many :flags
  should have_many(:captures).through(:redemptions)
  should 'find a team by ssl key guid'
end
