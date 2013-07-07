class Availability < ActiveRecord::Base
  belongs_to :instance
  belongs_to :round
end
