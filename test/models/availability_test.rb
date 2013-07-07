require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  should belong_to :instance
  should belong_to :round
end
