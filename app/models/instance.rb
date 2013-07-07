class Instance < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
end
