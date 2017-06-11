# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by(id: 1,
                       certname: 'ppp',
                       name: "Plaid Parliament of Pwning",
                       address: '10.5.1.2',
                       uuid: "b31d52d9-902f-4570-ae1a-9fbdde627d91")
Team.find_or_create_by(id: 2,
                       certname: 'bushwhackers',
                       name: "Bushwhackers",
                       address: '10.5.2.2',
                       uuid: "1526cdf6-57c7-44b9-b1c4-0bc8005fd4e6")
Team.find_or_create_by(id: 3,
                       certname: 'samurai',
                       name: "Samurai",
                       address: '10.5.3.2',
                       uuid: "13ceb49b-ea66-4c8c-9263-e3d53ef45885")
Team.find_or_create_by(id: 4,
                       certname: 'hitcon',
                       name: "HITCON",
                       address: '10.5.4.2',
                       uuid: "f437c4d7-93fe-45a3-8ae2-5519065ee905")
Team.find_or_create_by(id: 5,
                       certname: 'defkor',
                       name: "DEFKOR",
                       address: '10.5.5.2',
                       uuid: "fce9f25c-e973-4199-88f0-c46cb83c8625")
Team.find_or_create_by(id: 6,
                       certname: 'team-9447',
                       name: "9447",
                       address: '10.5.6.2',
                       uuid: "154c295b-9ff1-4aac-ba61-c7e1c11d4035")
Team.find_or_create_by(id: 7,
                       certname: 'gallopsled',
                       name: "Gallopsled",
                       address: '10.5.7.2',
                       uuid: "bfb7109a-e6bc-42b9-a626-2d893aa0791e")
Team.find_or_create_by(id: 8,
                       certname: 'blue-lotus',
                       name: "blue-lotus",
                       address: '10.5.8.2',
                       uuid: "003d93a8-86d1-4f4f-8a3f-1521f95cece4")
Team.find_or_create_by(id: 9,
                       certname: 'spamandhex',
                       name: "!SpamAndHex",
                       address: '10.5.9.2',
                       uuid: "807b9136-93c7-4339-bad4-d110a449b4ca")
Team.find_or_create_by(id: 10,
                       certname: 'corndump',
                       name: "CORNDUMP",
                       address: '10.5.10.2',
                       uuid: "d2d83a0b-a01c-424e-a9c6-0d412cc3ac75")
Team.find_or_create_by(id: 11,
                       certname: '0ops',
                       name: "0ops",
                       address: '10.5.11.2',
                       uuid: "38cad61b-c2da-46db-9404-51a1e1db7fda")
Team.find_or_create_by(id: 12,
                       certname: '0daysober',
                       name: "0daysober",
                       address: '10.5.12.2',
                       uuid: "127b3a43-5ab7-4b5a-b56b-547d26dbbd50")
Team.find_or_create_by(id: 13,
                       certname: 'dragonsector',
                       name: "Dragon Sector",
                       address: '10.5.13.2',
                       uuid: "18f67d96-791c-425c-98ab-a384db51a806")
Team.find_or_create_by(id: 14,
                       certname: 'shellphish',
                       name: "Shellphish",
                       address: '10.5.14.2',
                       uuid: "f65b3dd0-ed65-45df-b50b-28abb5f34934")
Team.find_or_create_by(id: 15,
                       certname: 'lcbc',
                       name: "LC\xE2\x86\xAFBC",
                       address: '10.5.15.2',
                       uuid: "5726c9eb-85eb-4bcf-b5a4-e6400cfe01bf")


Team.find_or_create_by(id: 16,
                       name: 'Legitimate Business Syndicate',
                       certname: 'legitbs',
                       uuid: "deadbeef-7872-499a-a060-3143de953e28",
                       address: "10.5.16.2"
                       )

regular_services = %w{
cr00semissile rxc irk irkd tachikoma ombdsu hackermud shittyvm badlog
}.map do |service_name|
  Service.find_or_create_by(name: service_name)
end

livectf_services = %w{
livectf_quals livectf_finals
}.map do |service_name|
  Service.find_or_create_by(name: service_name)
end

Team.find_each do |t|
  (livectf_services + regular_services).each do |s|
    Instance.find_or_create_by team_id: t.id, service_id: s.id
  end
end


Timer.find_or_create_by(name: 'game').
  update_attributes(ending: (Time.zone.parse('7-aug-2015 8pm pdt') + 14.hours))
Timer.find_or_create_by name: 'round'
Timer.
  find_or_create_by(name: 'friday').
  update_attributes(ending: Time.zone.parse('7-aug-2015 8pm pdt'))
Timer.
  find_or_create_by(name: 'saturday').
  update_attributes(ending: Time.zone.parse('8-aug-2015 8pm pdt'))
Timer.
  find_or_create_by(name: 'sunday').
  update_attributes(ending: Time.zone.parse('9-aug-2015 2pm pdt'))

Flag.delete_all

Flag.initial_distribution

Flag.collect_livectf_flags livectf_services
