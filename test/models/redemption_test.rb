require 'test_helper'

class RedemptionTest < ActiveSupport::TestCase
  should "resist redeeming the token more than once per team" do
    redemption = FactoryGirl.create :redemption

    assert_uniqueness_constraint do
      redemption2 = Redemption.create redemption.attributes
    end
  end
end
