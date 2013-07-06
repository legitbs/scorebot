class Capture < ActiveRecord::Base
  belongs_to :redemption
  belongs_to :flag
end
