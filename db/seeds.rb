# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by name: 'Samurai', certname: 'samurai'
Team.find_or_create_by name: 'PPP', certname: 'ppp'
Team.find_or_create_by name: 'Technopandas', certname: 'technopandas'
Team.find_or_create_by name: 'whois', certname: 'whois'
Team.find_or_create_by name: 'pwnies', certname: 'pwnies'
Team.find_or_create_by name: 'Euronop', certname: 'euronop'
Team.find_or_create_by name: 'more smoked leet chicken', certname: 'moresmoked'
Team.find_or_create_by name: 'blue lotus', certname: 'bluelotus'
Team.find_or_create_by name: 'routards', certname: 'routards'
Team.find_or_create_by name: 'shell corp', certname: '1shellcorp'
Team.find_or_create_by name: 'shellphish', certname: 'shellphish'
Team.find_or_create_by name: 'WOWHacker-BI0S', certname: 'wowhacker'
Team.find_or_create_by name: '9447', certname: '9447'
Team.find_or_create_by name: 'men in black hats', certname: 'meninblackhats'
Team.find_or_create_by name: 'clgt', certname: 'clgt'
Team.find_or_create_by name: 'sutegoma2', certname: 'sutegoma2'
Team.find_or_create_by name: 'pwningyeti', certname: 'pwningyeti'
Team.find_or_create_by name: 'apt8', certname: 'apt8'
Team.find_or_create_by name: 'Alternatives', certname: 'alternatives'
Team.find_or_create_by name: 'Robot Mafia', certname: 'robotmafia'

Team.find_or_create_by(name: 'Legitimate Business Syndicate', 
                       certname: 'legitbs', 
                       uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86")

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
Timer.find_or_create_by name: 'friday'
Timer.find_or_create_by name: 'saturday'
Timer.find_or_create_by name: 'sunday'
