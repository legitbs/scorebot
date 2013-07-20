require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  should belong_to :instance
  should belong_to :round

  should have_many :redemptions

  should validate_presence_of :instance
  should validate_presence_of :round

  context "token generation" do
    should "generate and validate a token string" do
      token = FactoryGirl.create :token
      token_str = token.to_token_string

      token2 = Token.from_token_string token_str
      assert_equal token, token2

      token.destroy
    end

    should "resist creating multiple tokens per instance-round" do
      token = FactoryGirl.create :token

      assert_uniqueness_constraint do
        token2 = Token.create token.attributes  
      end
    end
  end

  should "not be eligible after #{Token::EXPIRATION} rounds" do
    token = FactoryGirl.create :token
    assert token.eligible?
    
    Token::EXPIRATION.times do
      FactoryGirl.create :round
      assert token.eligible?
    end
    
    FactoryGirl.create :round
    refute token.eligible?
  end

  context 'Token redemption processing' do
    setup do
      @owned_team = FactoryGirl.create :team
      @instance = FactoryGirl.create :instance, team: @owned_team
      @round = FactoryGirl.create :round
      @token = FactoryGirl.create :token, round: @round, instance: @instance
      
      @flags = FactoryGirl.create_list(:flag, 19, team: @owned_team)
    end
    should 'process redemptions into captures' do
      @redemption = FactoryGirl.create :redemption, round: @round, token: @token

      @token.process_redemptions @round

      assert_not_empty @redemption.captures
      @flags.each &:reload
      assert @flags.all?{|f| f.team == @redemption.team }
    end
    should 'split flags evenly between competing teams' do
      @redemptions = FactoryGirl.create_list(:redemption, 
                                             19,
                                             round: @round, 
                                             token: @token)

      @capturing_teams = @redemptions.map(&:team)

      Capture.all.delete_all

      @token.process_redemptions @round

      assert_not_empty Capture.all

      @flags.each &:reload

      unchecked_flags = Set.new @flags

      Capture.all.each do |c|
        assert_includes unchecked_flags, c.flag
        unchecked_flags.delete c.flag
      end
    end
  end
end
