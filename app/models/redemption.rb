class Redemption < ActiveRecord::Base
  belongs_to :team
  belongs_to :token
end
