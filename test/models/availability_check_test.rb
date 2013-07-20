require 'test_helper'

class AvailabilityCheckTest < ActiveSupport::TestCase
  context 'Availability checking' do
    should 'check all the teams'
    should 'claim flags on failures'
  end
end
