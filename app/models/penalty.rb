class Penalty < ActiveRecord::Base
  belongs_to :availability
  belongs_to :team
  belongs_to :flag
end
