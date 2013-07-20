require 'test_helper'

class InstanceTest < ActiveSupport::TestCase
  should belong_to :service
  should belong_to :team
  should have_many :tokens
  should have_many :availabilities
  should have_many(:redemptions).through(:tokens)

  context 'Instance availability processing' do
    setup do
      @team = FactoryGirl.create :team
      @instance = FactoryGirl.create :instance, team: @team
      
      @round = FactoryGirl.create :round

      @flags = FactoryGirl.create_list :flag, 19, team: @team
    end
    should 'penalize flags when unavailable' do
      @new_av = FactoryGirl.
        build_stubbed(:down_availability, instance: @instance)
      Availability.
        expects(:check).
        with(@instance).
        returns(@new_av)

      @instance.check_availability

      assert @flags.all?{|f| f.reload.team != @team }
    end
    should 'not penalize flags when available' do
      @new_av = FactoryGirl.
        build_stubbed(:availability, instance: @instance)
      Availability.
        expects(:check).
        with(@instance).
        returns(@new_av)

      @instance.check_availability

      assert @flags.all?{|f| f.reload.team == @team }
    end
  end
end
