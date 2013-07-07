require 'test_helper'

class RedemptionTest < ActiveSupport::TestCase
  should belong_to :team
  should belong_to :token
  should "resist redeeming the token more than once per team" do
    redemption = FactoryGirl.create :redemption

    assert_uniqueness_constraint do
      redemption2 = Redemption.create redemption.attributes
    end
  end
end
