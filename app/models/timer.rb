class Timer < ActiveRecord::Base

  def self.feed
    j = proc{|e| e.ending}
    {
     today: j[today],
     game: j[game],
     round: j[round]
    }
  end

  def self.today
    Timer.where(name: 'friday').first
  end
  def self.game
    Timer.where(name: 'game').first
  end
  def self.round
    Timer.where(name: 'round').first
  end
    
  def remaining
    ending.to_i - Time.now.to_i
  end

  def ended?
    ending < Time.now
  end
end
