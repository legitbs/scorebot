class Penalty < ActiveRecord::Base
  belongs_to :availability
  belongs_to :team
end
