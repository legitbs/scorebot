require 'test_helper'

class RoundFinalizerTest < ActiveSupport::TestCase
  setup do
    @old_rounds = Token::EXPIRATION.times.map { FactoryGirl.create :round }
    @token = FactoryGirl.create :token, round: @old_rounds.first

    @redemption = FactoryGirl.create :redemption, token: @token
    @round = @redemption.round
    @instance = @token.instance
    @service = @instance.service
  end

  should 'be creatable with a round and service' do
    RoundFinalizer.new @round, @service
  end
  
  context 'with redemptions and failed availabilities' do
    setup do
      @owned_team = @instance.team
      @redeeming_team = @redemption.team
      @idle_team = FactoryGirl.create :team

      @failed_availability = FactoryGirl.create :down_availability, instance: @instance, round: @round

      @finalizer = RoundFinalizer.new @round, @service
    end

    should 'identify candidate tokens and failed availabilities' do
      assert_includes @finalizer.candidates, @token
      assert_includes @finalizer.candidates, @failed_availability
    end
    
    should 'scramble scoring events consistently' do
      assert_equal @finalizer.candidates, RoundFinalizer.new(@round, @service).candidates
    end

    should 'include the seed and sequence in the metadata'

    should 'score events in sequence'

  end
end
