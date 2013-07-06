require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  should belong_to :service
  should belong_to :team
end
