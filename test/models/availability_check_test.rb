require 'test_helper'

class AvailabilityCheckTest < ActiveSupport::TestCase
  setup do
    @round = FactoryGirl.create :current_round

    @legitbs = FactoryGirl.create :legitbs
    Team.stubs(:legitbs).returns(@legitbs)
    @general_teams = FactoryGirl.create_list :team, 20

    @service = FactoryGirl.create :service, name: 'noop', enabled: true
    @shell = stub 'shell', status: 0, output: 'okay'
    ShellProcess.stubs(:new).returns(@shell)

    @lbs_instance = FactoryGirl.create :instance, team: @legitbs, service: @service
    @instances = @general_teams.map{|t| Instance.create team: t, service: @service }
  end


  context 'initializing' do
    should 'initialize for a service' do
      assert @check = AvailabilityCheck.for_service(@service)

      assert_equal @lbs_instance, @check.lbs_instance
      assert_equal @instances, @check.non_lbs_instances
    end

    should 'cache instances' do
      assert(checker = AvailabilityCheck.for_service(@service))
      assert_equal checker.object_id, AvailabilityCheck.for_service(@service).object_id
    end
  end

  context 'timing' do
    setup do
      @check = AvailabilityCheck.for_service @service
    end

    should 'store timing history' do
      assert_respond_to @check, :timing_history
      assert_kind_of Enumerable, @check.timing_history
      assert_includes @check.timing_history, AvailabilityCheck::INITIAL_TIMING
    end

    should 'provide an average time' do
      assert_respond_to @check, :timing_average
      assert_kind_of Numeric, @check.timing_average
      @check.timing_history = [1, 2, 3]
      assert_equal 2.0, @check.timing_average
    end

    should 'warn if check will go longer than a round' do
      @check.timing_history = [ 2 * Round::ROUND_LENGTH ]
      assert @check.gonna_run_long?
    end

    should 'schedule checks for random times within the round'
  end

  context 'Availability checking' do
    should 'check all the teams' do
      lbs_av = stub 'legitbs availability', save: true
      @lbs_instance.expects(:check_availability).once.returns(lbs_av)

      @instances.each do |i|
        av = stub 'availability', status: 0
        i.expects(:check_availability).once.returns(av)
        av.expects(:save).once
      end

      @check = AvailabilityCheck.new @service

      @check.instance_variable_set(:@lbs_instance, @lbs_instance)
      @check.instance_variable_set(:@non_lbs_instances, @instances)

      assert_nothing_raised do
        @check.check_all_instances
      end
    end
    should 'claim flags on failures' do
      @check = AvailabilityCheck.new @service
      @check.instance_variable_set(:@lbs_check,
                                   stub('lbs availability', :healthy? => true))

      failure = stub('failed', :healthy? => false)
      okay = stub('okay', :healthy? => true)
      checks = [failure] + [okay] * 19

      @check.instance_variable_set(:@non_lbs_checks, checks)

      failure.expects(:distribute!)

      assert_nothing_raised do
        @check.distribute_flags
      end
    end
  end
end
