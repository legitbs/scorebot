class Replacement < ApplicationRecord
  belongs_to :team
  belongs_to :service
  belongs_to :round
end
