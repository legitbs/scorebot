class Flag < ActiveRecord::Base
  belongs_to :team
  belongs_to :service
  has_many :captures

  TOTAL_FLAGS = 11 * # service count
                15 * # team count
                1337

  def self.initial_distribution
    raise "Refusing to distribute with existing flags" unless Flag.count == 0

    transaction do
      teams = Team.without_legitbs.to_a
      services = Service.all

      tranche_count = teams.count * services.count
      tranche_size = Flag::TOTAL_FLAGS / (tranche_count)
      tranche_remainder = Flag::TOTAL_FLAGS % (tranche_count)

      unless tranche_remainder == 0
        puts "#{teams.count} teams * #{services.count} services = #{tranche_count} tranches"
        puts "#{Flag::TOTAL_FLAGS} / #{tranche_count} = #{Flag::TOTAL_FLAGS.to_f / tranche_count.to_f}"
        puts "add #{tranche_size - tranche_remainder} or remove #{tranche_remainder}"
        raise "had flags left over when planning allocation"
      end

      puts "#{services.count} services, #{teams.count} teams, #{tranche_size} flags per"

      teams.each do |t|
        print "flags for #{t.name}: "
        services.each do |s|
          tranche_size.times do
            Flag.create team: t, service: s
          end
          print '.'
        end

        puts
      end
    end
  end
end
