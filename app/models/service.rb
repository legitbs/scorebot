class Service < ActiveRecord::Base
  has_many :instances
  has_many :flags
  scope :enabled, -> { where(enabled: true) }

  def total_redemptions
    instances.joins(:tokens).sum(:redemptions_count)
  end
end
