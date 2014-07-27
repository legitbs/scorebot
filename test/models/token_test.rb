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

  context 'token deposition' do
    setup do
      @instance = FactoryGirl.create :instance
      @round = FactoryGirl.create :round
    end
    should 'run a per-service deposit script' do
      @shell = mock('shell', output: 'example', status: 0)

      ShellProcess.
        expects(:new).
        with{ |e| e == Rails.root.join('scripts', @instance.service.name, 'deposit') }.
        returns(@shell)

      @token = Token.create instance: @instance, round: @round
      @token.deposit

      assert_equal @token, Token.from_token_string(@token.to_token_string)
    end
    should 'allow deposit scripts to substitute tokens' do
      replaced_token = "replaced-token-#{rand(36**5).to_s(36)}"
      @shell = mock('shell', output: "!!legitbs-replace-token #{replaced_token}", status: 0)

      ShellProcess.
        expects(:new).
        with{|e| e == Rails.root.join('scripts', @instance.service.name, 'deposit') }.
        returns(@shell)

      @token = Token.create instance: @instance, round: @round
      @token.deposit

      assert_equal @token, Token.from_token_string(replaced_token)
    end
  end

  should "not be eligible after #{Token::EXPIRATION} rounds" do
    token = FactoryGirl.create :token
    assert token.eligible?
    
    Token::EXPIRATION.times do
      FactoryGirl.create :round
      assert token.eligible?
    end

    refute_includes Token.expiring, token
    
    FactoryGirl.create :round
    refute token.eligible?

    assert_includes Token.expiring, token
  end
end
