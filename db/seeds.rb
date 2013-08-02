# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by name: 'Samurai', certname: 'samurai', joe_name: "samurai", address: "10.5.6.2", uuid: '8e142c4e-c30c-423b-868a-bc17ea1bdca3'

Team.find_or_create_by name: 'PPP', certname: 'ppp', joe_name: "ppp", address: "10.5.1.2", uuid: 'ae88ccf6-647f-413d-8104-f7dade898c10'

Team.find_or_create_by name: '[Technopandas]', certname: 'technopandas', joe_name: "technopandas", address: "10.5.2.2", uuid: 'df69e275-a8c5-40c7-9130-1d9d1ac5a720'

Team.find_or_create_by name: 'raon_ASRT', certname: 'whois', joe_name: "whois", address: "10.5.4.2", uuid: 'f868496b-bced-4e5d-b209-970bf2d4a835'

Team.find_or_create_by name: 'pwnies', certname: 'pwnies', joe_name: "pwnies", address: "10.5.5.2", uuid: 'a5ec8bca-b161-44cb-95b5-e2f879350fb2'

Team.find_or_create_by name: 'The European Nopsled Team', certname: 'euronop', joe_name: "euronop", address: "10.5.7.2", uuid: '45744a3b-d76d-4837-b63a-05e1f9400690'

Team.find_or_create_by name: 'more smoked leet chicken', certname: 'moresmoked', joe_name: "moresmoked", address: "10.5.9.2", uuid: 'bf4a9b7e-4070-4ec4-a001-da566400d4b3'

Team.find_or_create_by name: 'blue lotus', certname: 'bluelotus', joe_name: "bluelotus", address: "10.5.10.2", uuid: '0ca37344-5c70-4c9f-b9c8-22d2ed9a7e8f'

Team.find_or_create_by name: 'routards', certname: 'routards', joe_name: "routards", address: "10.5.11.2", uuid: '02f267c9-0d6f-482e-939b-c6105f2e78e2'

Team.find_or_create_by name: 'shell corp', certname: '1shellcorp', joe_name: "shellcorp", address: "10.5.12.2", uuid: 'd7634d2f-5cd4-4495-bcab-63cb88d14220'

Team.find_or_create_by name: 'shellphish', certname: 'shellphish', joe_name: "shellphish", address: "10.5.13.2", uuid: '21e896be-e24b-4c1a-a52a-8ec4b06cf7e1'

Team.find_or_create_by name: 'WOWHacker-BI0S', certname: 'wowhacker', joe_name: "wowhacker", address: "10.5.14.2", uuid: '34ea4c06-24ca-48bb-a2dc-6cd3dc03775f'

Team.find_or_create_by name: '9447', certname: '9447', joe_name: "team9447", address: "10.5.15.2", uuid: 'b50e33bd-413b-4bd8-ba77-04611027c1eb'

Team.find_or_create_by name: 'men in black hats', certname: 'meninblackhats', joe_name: "meninblackhats", address: "10.5.16.2", uuid: '798965c8-00cb-4e55-8ad5-cbf614995255'

Team.find_or_create_by name: 'clgt', certname: 'clgt', joe_name: "clgt", address: "10.5.3.2", uuid: '7402a30f-f6fe-4131-82da-190dfcba35d3'

Team.find_or_create_by name: 'sutegoma2', certname: 'sutegoma2', joe_name: "sutegoma2", address: "10.5.8.2", uuid: 'd2c6f957-cc15-4f92-adce-1311f58d91cf'

Team.find_or_create_by name: 'pwningyeti', certname: 'pwningyeti', joe_name: "pwningyeti", address: "10.5.17.2", uuid: '35a08be7-39ea-4d13-9ddc-3885c71c9be5'

Team.find_or_create_by name: 'APT88', certname: 'apt8', joe_name: "apt8", address: "10.5.18.2", uuid: 'f62dc293-f955-45cc-a60b-fcb6eea3e971'

Team.find_or_create_by name: 'Alternatives', certname: 'alternatives', joe_name: "alternatives", address: "10.5.19.2", uuid: '0cbfeec7-031a-4513-ad02-4c3dccaf63e7'

Team.find_or_create_by name: 'Robot Mafia', certname: 'robotmafia', joe_name: "robotmafia", address: "10.5.20.2", uuid: 'bbe462be-c289-4646-86b0-83c80870fcbc'


Team.find_or_create_by(name: 'Legitimate Business Syndicate', 
                       certname: 'legitbs', 
                       uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86",
                       joe_name: 'oracle',
                       address: "10.5.22.2"
                       )

Service.find_or_create_by name: 'atmail', enabled: true
Service.find_or_create_by name: 'bookworm', enabled: true
# Service.find_or_create_by name: 'trouver'
Service.find_or_create_by name: 'lonetuna', enabled: true
# Service.find_or_create_by name: 'redmoose'
# Service.find_or_create_by name: 'coldfinger'
# Service.find_or_create_by name: 'avoir'
# Service.find_or_create_by name: 'bookworm'
# Service.find_or_create_by name: 'hopper'
# Service.find_or_create_by name: 'nginsh'
# Service.find_or_create_by name: 'where in the world is edward'
# Service.find_or_create_by name: 'The Symz'

Team.find_each do |t|
  Service.find_each do |s|
    Instance.find_or_create_by team_id: t.id, service_id: s.id
  end
end

Timer.find_or_create_by(name: 'game').
  update_attributes(ending: (Time.zone.parse('2-aug-2013 8pm pdt') + 14.hours))
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
  n = Flag::TOTAL_FLAGS - Flag.count
  (Flag::TOTAL_FLAGS - Flag.count).times do
    n -= 1
    Scorebot.log n if n % 100 == 0
    t = teams.shift
    Flag.create team: t
    teams.push t
  end
end

Message.
  find_or_create_by(body: "Welcome to DEF CON CTF 2013.")
