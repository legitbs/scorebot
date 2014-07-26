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
        with{|e| e == Rails.root.join('scripts', @instance.service.name, 'availability')}.
        returns(@shell)

      @token = FactoryGirl.create :token, instance: @instance
      @dingus = [rand(2**64).to_s(16)].pack('H*')

      @memo = <<-EOF
example memo
!!legitbs-validate-token #{@token.to_token_string}
!!legitbs-validate-dev-ctf #{Base64.strict_encode64 @dingus}
EOF

      @shell.expects(:status).returns(0)
      @shell.expects(:output).returns(@memo)
    end

    should 'create an availability from an instance' do
      @availability = Availability.check @instance, @round

      assert @availability
      assert_equal 0, @availability.status
      assert_equal @memo, @availability.memo

      assert_equal @dingus, @availability.dingus
      assert_equal @token, @availability.token
    end
  end

  should 'log flag distribution'
end
