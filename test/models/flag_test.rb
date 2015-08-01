require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  should belong_to :team
  should have_many :captures
  end
end
