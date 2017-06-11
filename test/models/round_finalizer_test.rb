require 'test_helper'

class RoundFinalizerTest < ActiveSupport::TestCase
  setup do
    @old_rounds = Token::EXPIRATION.times.map { FactoryGirl.create :round }
    @token = FactoryGirl.create :token, round: @old_rounds.first

    @redemption = FactoryGirl.create :redemption, token: @token
    @round = @redemption.round
    @instance = @token.instance
    @service = @instance.service

    @lbs_instance = FactoryGirl.create :lbs_instance, service: @service
  end

  should 'be creatable with a round and service' do
    RoundFinalizer.new @round, @service
  end

  context 'with redemptions and failed availabilities' do
    setup do
      @owned_team = @instance.team
      @redeeming_team = @redemption.team
      @idle_team = FactoryGirl.create :team

      @lbs_availability = FactoryGirl.create :availability, instance: @lbs_instance, round: @round
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

    should 'include the seed and sequence in the metadata' do
      assert_includes @finalizer.as_metadata_json, :seed
      assert_includes @finalizer.as_metadata_json, :sequence
    end

    should 'score events in sequence' do
      seq = sequence 'scoring'
      @finalizer.candidates.each do |c|
        c.expects(:process_movements).once.in_sequence(seq)
        c.expects(:as_movement_json).once.in_sequence(seq).returns(:ok)
      end

      @finalizer.movements
    end

    should 'have sensible movement data' do
      assert_kind_of Array, @finalizer.movements
      @finalizer.movements.each do |m|
        assert_kind_of Hash, m
      end
    end
  end
end
