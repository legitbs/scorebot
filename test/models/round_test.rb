require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  should have_many :availabilities
  should have_many :tokens
  should have_many :redemptions

  should 'happen periodically'
  should 'run availability checks once and only once'

  context 'class methods' do
    should 'get the current round' do
      r1 = FactoryGirl.create :round
      
      assert_equal r1, Round.current
      
      r2 = FactoryGirl.create :round
      
      assert_equal r2, Round.current
    end
    
    should 'get the rounds since a given round' do
      r1 = FactoryGirl.create :round

      assert_equal 0, Round.since(r1)

      (1..5).each do |n|
        FactoryGirl.create :round
        assert_equal n, Round.since(r1)
      end
    end
  end
end
