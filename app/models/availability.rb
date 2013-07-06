class Availability < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
  belongs_to :round
end
