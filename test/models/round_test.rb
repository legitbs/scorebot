require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  should have_many :availabilities
  should have_many :tokens
  should have_many :redemptions
  should 'happen periodically'
  should 'process redemptions into captures at round end'
end
