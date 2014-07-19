class Service < ActiveRecord::Base
  has_many :instances
  has_many :flags
end
