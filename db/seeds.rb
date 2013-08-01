# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by name: 'Samurai', certname: 'samurai', joe_name: "samurai", address: "10.5.6.2"

Team.find_or_create_by name: 'PPP', certname: 'ppp', joe_name: "ppp", address: "10.5.1.2"

Team.find_or_create_by name: '[Technopandas]', certname: 'technopandas', joe_name: "technopandas", address: "10.5.2.2"

Team.find_or_create_by name: 'raon_ASRT', certname: 'whois', joe_name: "whois", address: "10.5.4.2"

Team.find_or_create_by name: 'pwnies', certname: 'pwnies', joe_name: "pwnies", address: "10.5.5.2"

Team.find_or_create_by name: 'The European Nopsled Team', certname: 'euronop', joe_name: "euronop", address: "10.5.7.2"

Team.find_or_create_by name: 'more smoked leet chicken', certname: 'moresmoked', joe_name: "moresmoked", address: "10.5.9.2"

Team.find_or_create_by name: 'blue lotus', certname: 'bluelotus', joe_name: "bluelotus", address: "10.5.10.2"

Team.find_or_create_by name: 'routards', certname: 'routards', joe_name: "routards", address: "10.5.11.2"

Team.find_or_create_by name: 'shell corp', certname: '1shellcorp', joe_name: "shellcorp", address: "10.5.12.2"

Team.find_or_create_by name: 'shellphish', certname: 'shellphish', joe_name: "shellphish", address: "10.5.13.2"

Team.find_or_create_by name: 'WOWHacker-BI0S', certname: 'wowhacker', joe_name: "wowhacker", address: "10.5.14.2"

Team.find_or_create_by name: '9447', certname: '9447', joe_name: "team9447", address: "10.5.15.2"

Team.find_or_create_by name: 'men in black hats', certname: 'meninblackhats', joe_name: "meninblackhats", address: "10.5.16.2"

Team.find_or_create_by name: 'clgt', certname: 'clgt', joe_name: "clgt", address: "10.5.3.2"

Team.find_or_create_by name: 'sutegoma2', certname: 'sutegoma2', joe_name: "sutegoma2", address: "10.5.8.2"

Team.find_or_create_by name: 'pwningyeti', certname: 'pwningyeti', joe_name: "pwningyeti", address: "10.5.17.2"

Team.find_or_create_by name: 'APT88', certname: 'apt8', joe_name: "apt8", address: "10.5.18.2"

Team.find_or_create_by name: 'Alternatives', certname: 'alternatives', joe_name: "alternatives", address: "10.5.19.2"

Team.find_or_create_by name: 'Robot Mafia', certname: 'robotmafia', joe_name: "robotmafia", address: "10.5.20.2"


Team.find_or_create_by(name: 'Legitimate Business Syndicate', 
                       certname: 'legitbs', 
                       uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86",
                       joe_name: 'oracle',
                       address: "10.5.21.2"
                       )

Service.find_or_create_by name: 'trouver'
Service.find_or_create_by name: 'lonetuna'
Service.find_or_create_by name: 'redmoose'
Service.find_or_create_by name: 'coldfinger'
Service.find_or_create_by name: 'avoir'
Service.find_or_create_by name: 'bookworm'
Service.find_or_create_by name: 'hopper'
Service.find_or_create_by name: 'nginsh'
Service.find_or_create_by name: 'where in the world is edward'
Service.find_or_create_by name: 'The Symz'

Team.find_each do |t|
  Service.find_each do |s|
    Instance.find_or_create_by team_id: t.id, service_id: s.id
  end
end

Timer.find_or_create_by name: 'game'
Timer.find_or_create_by name: 'round'
Timer.
  find_or_create_by(name: 'friday').
  update_attributes(ending: Time.zone.parse('2-aug-2013 8pm pdt'))
Timer.
  find_or_create_by(name: 'saturday').
  update_attributes(ending: Time.zone.parse('3-aug-2013 8pm pdt'))
Timer.
  find_or_create_by(name: 'sunday').
  update_attributes(ending: Time.zone.parse('4-aug-2013 2pm pdt'))

Flag.transaction do
  teams = Team.without_legitbs.to_a
  (Flag::TOTAL_FLAGS - Flag.count).times do
    t = teams.shift
    Flag.create team: t
    teams.push t
  end
end

Message.
  find_or_create_by(body: "Welcome to DEF CON CTF 2013.")
