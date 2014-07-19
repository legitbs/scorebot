require 'test_helper'

class RedemptionTest < ActiveSupport::TestCase
  should belong_to :team
  should belong_to :token
  should have_many :captures
  should have_many(:flags).through(:captures)

  should "redeem for a team" do
    team = FactoryGirl.create :team
    token = FactoryGirl.create :token

    r = Redemption.redeem_for team, token.to_token_string

    assert r.persisted?
    assert_empty r.errors
  end

  context 'error cases' do
    
    should "resist redeeming the token more than once per team" do
      redemption = FactoryGirl.create :redemption

      assert_uniqueness_constraint do
        redemption2 = Redemption.create redemption.attributes
      end
    end

    should "refuse to redeem after token expiration" do
      team = FactoryGirl.create :team
      token = FactoryGirl.create :token
      assert token.eligible?
      
      Token::EXPIRATION.times do
        FactoryGirl.create :round
        assert_nothing_raised { Redemption.redeem_for team, token.to_token_string }
        token.redemptions.destroy_all
      end
      
      FactoryGirl.create :round
      assert_raises(Redemption::OldTokenError) { Redemption.redeem_for team, token.to_token_string }
    end

    should 'refuse to redeem for the token-owning team'
  end
end
