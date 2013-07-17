class Instance < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
  
  has_many :tokens
  has_many :redemptions, through: :tokens
  
  has_many :availabilities
end
