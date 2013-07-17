class Round < ActiveRecord::Base
  has_many :availabilities
  has_many :tokens
  has_many :redemptions
end
