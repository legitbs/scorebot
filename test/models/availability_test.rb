require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  should belong_to :instance
  should belong_to :round

  context 'with a round, an instance, and a shell process' do
    setup do
      @instance = FactoryGirl.create :instance

      @shell = mock('shell')
      ShellProcess.
        expects(:new).
        with(Rails.root.join('scripts', @instance.service.name),
             'availability',
             is_a(Integer)).
        returns(@shell)

      @token = FactoryGirl.create :token, instance: @instance
      @dingus = [rand(2**64).to_s(16)].pack('H*')

      @memo = <<-EOF
example memo
!!legitbs-validate-token-7OPuwAj #{@token.to_token_string}
EOF

      @shell.expects(:status).returns(0)
      @shell.expects(:output).at_least(1).returns(@memo)
    end

    should 'create an availability from an instance' do
      @availability = Availability.check @instance, @round

      assert @availability
      assert_equal 0, @availability.status
      assert_equal @memo, @availability.memo

      assert_equal @token, @availability.token
    end
  end

  should 'distribute flags' do
    @instance = FactoryGirl.create :instance
    @lbs_instance = FactoryGirl.create :lbs_instance, service: @instance.service

    @flags = FactoryGirl.create_list :flag, 19, team: @instance.team, service: @instance.service
    @teams = FactoryGirl.create_list :team, 19

    @availability = FactoryGirl.create :down_availability, instance: @instance
    @lbs_availability = FactoryGirl.create(:availability,
                                           instance: @lbs_instance,
                                           round: @availability.round)

    @availability.process_movements(@availability.round)

    assert @flags.any?{|f| f.reload.team != @instance.team}
  end

  should 'log flag distribution'
end
