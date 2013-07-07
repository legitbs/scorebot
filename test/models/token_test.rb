require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  should belong_to :instance
  should belong_to :round

  should validate_presence_of :instance
  should validate_presence_of :round

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
