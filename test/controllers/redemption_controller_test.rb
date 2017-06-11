require 'test_helper'

class RedemptionControllerTest < ActionController::TestCase
  context 'redeeming tokens' do
    setup do
      @round = FactoryGirl.create :round
      @current_team = FactoryGirl.create :team
      @request.headers['HTTP_SSL_CLIENT_S_DN_CN'] = @current_team.uuid
    end

    should 'return json on an empty token set' do
      @token = FactoryGirl.create :token

      post :create, params: { tokens: [] }

      assert_response :success
      assert_equal Hash.new, JSON.parse(response.body)
    end

    should 'return json and a valid redemption with a single token' do
      @token = FactoryGirl.create :token
      @ts = @token.to_token_string

      post :create, params: { tokens: [@ts] }

      assert_response :success
      assert_equal({@ts => @token.redemptions.first.uuid}, JSON.parse(response.body))
    end

    should 'return json with error messages' do
      @token = FactoryGirl.create :token
      (Token::EXPIRATION + 1).times{ FactoryGirl.create :round }
      @ts = @token.to_token_string

      @token2 = FactoryGirl.create :token
      @ts2 = @token2.to_token_string
      @existing_redemption = Redemption.redeem_for @current_team, @ts2

      post :create, params: { tokens: [@ts, @ts2] }

      assert_response :success
      assert_equal({
                     @ts => 'error: Token too old',
                     @ts2 => 'error: Already redeemed that token'
                   }, JSON.parse(response.body))
    end
  end
end
