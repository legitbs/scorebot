require 'test_helper'

class CaptureTest < ActiveSupport::TestCase
  should have_one(:team).through(:redemption)
  should belong_to :flag
  should belong_to :redemption

  should 'update the captured flag'
end
