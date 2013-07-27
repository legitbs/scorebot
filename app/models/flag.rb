class Flag < ActiveRecord::Base
  belongs_to :team
  has_many :captures

  TOTAL_FLAGS = 50_000
end
