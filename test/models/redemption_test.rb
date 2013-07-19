require 'test_helper'

class RedemptionTest < ActiveSupport::TestCase
  should belong_to :team
  should belong_to :token
  should have_many :captures
  should have_many(:flags).through(:captures)

  should "resist redeeming the token more than once per team" do
    redemption = FactoryGirl.create :redemption

    assert_uniqueness_constraint do
      redemption2 = Redemption.create redemption.attributes
    end
  end

  should "redeem for a team" do
    team = FactoryGirl.create :team
    token = FactoryGirl.create :token

    r = Redemption.redeem_for team, token.to_token_string

    assert r.persisted?
    assert_empty r.errors
  end
end
