require 'test_helper'

class FlagTest < ActiveSupport::TestCase
  should belong_to :team
  should have_many :captures

  context 'reallocation' do
    should "reallocate flags to scoring teams" do
      @round = FactoryGirl.create :round
      @redemptions = FactoryGirl.create_list(:redemption, 14, round: @round)
      
      @teams = @redemptions.map(&:team)
      @legitbs = FactoryGirl.create :legitbs

      @flags = FactoryGirl.create_list(:flag, 17, team: @legitbs)

      Flag.reallocate @round

      @found_teams = Hash.new
      @lbs_count = 0

      @flags.each do |f|
        f.reload
        if f.team == @legitbs
          @lbs_count += 1
        else
          @found_teams[f.team] = f
        end
      end

      @teams.each do |t|
        assert_not_nil @found_teams[t]
      end
      
      assert_equal 3, @lbs_count
    end
  end
end
