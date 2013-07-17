require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  should have_many :instances
end
