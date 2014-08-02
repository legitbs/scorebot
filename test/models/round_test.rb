require 'test_helper'

class RoundTest < ActiveSupport::TestCase
  should have_many :availabilities
  should have_many :tokens
  should have_many :redemptions

  should 'run availability checks once and only once' do
    @round = FactoryGirl.create :round
    @service = FactoryGirl.create :service, enabled: true
    @instance = FactoryGirl.create :instance, service: @service
    @lbs_instance = FactoryGirl.create :lbs_instance, service: @service

    Availability.any_instance.stubs(:check)
    ShellProcess.stubs(:new).returns(@shell)

    refute @round.availability_checks_done?

    @round.check_availability

    assert @round.availability_checks_done?

    @round.check_availability
  end

  should 'find expiring tokens' do
    @old_rounds = (Token::EXPIRATION + 2).times.map{ FactoryGirl.create :round }
    @round = FactoryGirl.create :round

    @ancient_token = FactoryGirl.create :token, round: @old_rounds.first
    @expiring_token = FactoryGirl.create :token, round: @old_rounds.second
    @new_token = FactoryGirl.create :token, round: @round

    refute_includes @round.expiring_tokens, @ancient_token
    assert_includes @round.expiring_tokens, @expiring_token
    refute_includes @round.expiring_tokens, @new_token
    
    assert_equal Set.new(@round.expiring_tokens), Set.new(Token.expiring)
  end

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
