class Ticket < ActiveRecord::Base
  belongs_to :team
  scope :unresolved, -> { where(resolved_at: nil) }

  def resolve!
    update_attribute :resolved_at, Time.now
  end
end
