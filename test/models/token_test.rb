require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  should belong_to :service
  should belong_to :team
  should belong_to :round

  should validate_presence_of :service
  should validate_presence_of :team
  should validate_presence_of :round

  should "generate and validate a token string" do
   token = FactoryGirl.create :token
   token_str = token.to_token_string

   token2 = Token.from_token_string token_str
   assert_equal token, token2

   token.destroy
  end

  should "resist creating multiple tokens per service-team-round" do
    token = FactoryGirl.create :token

    assert_uniqueness_constraint do
      token2 = Token.create token.attributes  
    end
  end
end
