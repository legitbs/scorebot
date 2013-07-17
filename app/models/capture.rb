class Capture < ActiveRecord::Base
  belongs_to :redemption
  belongs_to :flag
  has_one :team, through: :redemption
end
