require 'test_helper'

class CaptureTest < ActiveSupport::TestCase
  should have_one(:team).through(:redemption)
  should belong_to :flag
  should belong_to :redemption
  should belong_to :round

  should 'update the captured flag' do
    @flag = FactoryGirl.create :flag

    old_tem = @flag.team
    @capture = FactoryGirl.create :capture, flag: @flag

    assert_equal @capture.team, @flag.team
  end
end
