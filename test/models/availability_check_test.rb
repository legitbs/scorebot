require 'test_helper'

class AvailabilityCheckTest < ActiveSupport::TestCase
  setup do
    @legitbs = FactoryGirl.create :legitbs
    Team.stubs(:legitbs).returns(@legitbs)
    @general_teams = FactoryGirl.create_list :team, 20

    @service = FactoryGirl.create :service, name: 'noop'
    @shell = stub 'shell', status: 0, output: 'okay'
    ShellProcess.stubs(:new).returns(@shell)

    @lbs_instance = FactoryGirl.create :instance, team: @legitbs, service: @service
    @instances = @general_teams.map{|t| Instance.create team: t, service: @service }
  end
  
  should 'be creatable for a service' do

    @check = AvailabilityCheck.new @service

    assert_equal @lbs_instance, @check.lbs_instance
    assert_equal @instances, @check.non_lbs_instances
  end

  context 'Availability checking' do
    should 'check all the teams' do
      @lbs_instance.expects(:check_availability).once

      @instances.each{|i| i.expects(:check_availability).once}

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
