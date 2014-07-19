# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by(id: 1, certname: 'ppp', name: "Plaid Parliament of Pwning", address: '10.5.1.2')
Team.find_or_create_by(id: 2, certname: 'team9447', name: "9447", address: '10.5.2.2')
Team.find_or_create_by(id: 3, certname: 'reckless', name: "Reckless Abandon", address: '10.5.3.2')
Team.find_or_create_by(id: 4, certname: 'routards', name: "Routards", address: '10.5.4.2')
Team.find_or_create_by(id: 5, certname: 'raon_asrt', name: "raon_ASRT", address: '10.5.5.2')
Team.find_or_create_by(id: 6, certname: 'kaist', name: "KAIST GoN", address: '10.5.6.2')
Team.find_or_create_by(id: 7, certname: 'shellphish', name: "shellphish", address: '10.5.7.2')
Team.find_or_create_by(id: 8, certname: 'codered', name: "CodeRed", address: '10.5.8.2')
Team.find_or_create_by(id: 9, certname: 'hitcon', name: "HITCON", address: '10.5.9.2')
Team.find_or_create_by(id: 10,  certname: 'blue-lotus', name: "blue-lotus", address: '10.5.10.2')
Team.find_or_create_by(id: 11,  certname: 'hackingforchimac', name: "HackingForChiMac", address: '10.5.11.2')
Team.find_or_create_by(id: 12,  certname: 'mmibh', name: "(Mostly) Men in Black Hats", address: '10.5.12.2')
Team.find_or_create_by(id: 13,  certname: 'w3stormz', name: "w3stormz", address: '10.5.13.2')
Team.find_or_create_by(id: 14,  certname: 'mslc', name: "More Smoked Leet Chicken", address: '10.5.14.2')
Team.find_or_create_by(id: 15,  certname: 'dragonsector', name: "Dragon Sector", address: '10.5.15.2')
Team.find_or_create_by(id: 16,  certname: 'penthackon', name: "[SEWorks]penthackon", address: '10.5.16.2')
Team.find_or_create_by(id: 17,  certname: 'stratum', name: "Stratum Auhuur", address: '10.5.17.2')
Team.find_or_create_by(id: 18,  certname: 'gallopsled', name: "Gallopsled", address: '10.5.18.2')
Team.find_or_create_by(id: 19,  certname: 'balalaikacr3w', name: "BalalaikaCr3w", address: '10.5.19.2')
Team.find_or_create_by(id: 20,  certname: 'binja', name: "binja", address: '10.5.20.2')

Team.find_or_create_by(id: 21,
                       name: 'Legitimate Business Syndicate', 
                       certname: 'legitbs', 
                       uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86",
                       address: "10.5.22.2"
                       )

Service.find_or_create_by(name: 'eliza')
Service.find_or_create_by(name: 'wdub')
Service.find_or_create_by(name: 'malvo')
Service.find_or_create_by(name: 'badge')
Service.find_or_create_by(name: 'justify')
Service.find_or_create_by(name: 'imap')
Service.find_or_create_by(name: 'hellnet')

Team.find_each do |t|
  Service.find_each do |s|
    Instance.find_or_create_by team_id: t.id, service_id: s.id
  end
end

Timer.find_or_create_by(name: 'game').
  update_attributes(ending: (Time.zone.parse('8-aug-2014 8pm pdt') + 14.hours))
Timer.find_or_create_by name: 'round'
Timer.
  find_or_create_by(name: 'friday').
  update_attributes(ending: Time.zone.parse('8-aug-2014 8pm pdt'))
Timer.
  find_or_create_by(name: 'saturday').
  update_attributes(ending: Time.zone.parse('9-aug-2014 8pm pdt'))
Timer.
  find_or_create_by(name: 'sunday').
  update_attributes(ending: Time.zone.parse('10-aug-2014 2pm pdt'))

Flag.delete_all

Flag.transaction do
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
