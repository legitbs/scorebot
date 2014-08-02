class Service < ActiveRecord::Base
  has_many :instances
  has_many :flags

  def total_redemptions
    instances.joins(:tokens).sum(:redemptions_count)
  end
end
