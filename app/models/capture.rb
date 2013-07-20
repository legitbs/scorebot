class Capture < ActiveRecord::Base
  belongs_to :redemption
  belongs_to :flag
  belongs_to :round
  has_one :team, through: :redemption

  before_create :update_flag_team

  private
  def update_flag_team
    flag.team = self.team
    flag.save
  end
end
