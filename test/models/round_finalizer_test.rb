require 'test_helper'

class RoundFinalizerTest < ActiveSupport::TestCase
  should 'be creatable with a round and service'
  should 'redistribute flags from redemptions and failed availabilities'
  should 'calculate number of flags each team is due'
  should 'prioritize flags for winning-est teams'
  should 'record distributions on the round'
end
