require 'test_helper'

class AvailabilityTest < ActiveSupport::TestCase
  should belong_to :instance
  should belong_to :round

  should 'create an availability from an instance' do
    @instance = FactoryGirl.create :instance

    @shell = mock('shell')
    ShellProcess.
      expects(:new).
      with{|e| e == Rails.root.join('scripts', @instance.service.name, 'availability')}.
      returns(@shell)

    @shell.expects(:status).returns(0)
    @shell.expects(:output).returns("example memo")

    @round = FactoryGirl.create :round

    @availability = Availability.check @instance

    assert @availability
    assert_equal 0, @availability.status
    assert_equal "example memo", @availability.memo
  end
end
