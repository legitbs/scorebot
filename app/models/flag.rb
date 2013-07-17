class Flag < ActiveRecord::Base
  belongs_to :team
  has_many :captures
end
