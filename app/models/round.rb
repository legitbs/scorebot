class Round < ActiveRecord::Base
  has_many :availabilities
  has_many :tokens
  has_many :redemptions

  def self.current
    order('created_at desc').first
  end

  def self.since(round)
    where('created_at > ?', round.created_at).size
  end
end
