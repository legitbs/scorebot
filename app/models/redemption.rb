class Redemption < ActiveRecord::Base
  belongs_to :team
  belongs_to :token
  belongs_to :round
  has_many :captures
  has_many :flags, through: :captures
end
