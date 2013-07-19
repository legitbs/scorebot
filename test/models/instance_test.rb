require 'test_helper'

class InstanceTest < ActiveSupport::TestCase
  should belong_to :service
  should belong_to :team
  should have_many :tokens
  should have_many :availabilities
  should have_many(:redemptions).through(:tokens)
end
