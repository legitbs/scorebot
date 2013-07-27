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
    
end
