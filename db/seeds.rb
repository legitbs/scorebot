# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by(id: 1,   certname: 'ppp', name: "Plaid Parliament of Pwning", address: '10.5.1.2', uuid: "f2bad371-32b8-49b2-a32f-b8537d7b7ccd")
Team.find_or_create_by(id: 2,   certname: 'team9447', name: "9447", address: '10.5.2.2', uuid: "4c104f16-64c9-46b3-a63b-5f5c44c6b9bd")
Team.find_or_create_by(id: 3,   certname: 'reckless', name: "Reckless Abandon", address: '10.5.3.2', uuid: "8ffe304a-d2db-4374-867c-fac6982ffd2d")
Team.find_or_create_by(id: 4,   certname: 'routards', name: "Routards", address: '10.5.4.2', uuid: "aa5930d4-79fe-4c9d-8339-e3ee722af218")
Team.find_or_create_by(id: 5,   certname: 'raon_asrt', name: "raon_ASRT", address: '10.5.5.2', uuid: "f20e3f10-c6d0-47ef-bc2f-7c16323b5423")
Team.find_or_create_by(id: 6,   certname: 'kaist', name: "KAIST GoN", address: '10.5.6.2', uuid: "c3f5cc9a-b382-40e1-97f6-440c66d21680")
Team.find_or_create_by(id: 7,   certname: 'shellphish', name: "shellphish", address: '10.5.7.2', uuid: "917ebc33-cc69-4f02-8c30-a54b75fd5f42")
Team.find_or_create_by(id: 8,   certname: 'codered', name: "CodeRed", address: '10.5.8.2', uuid: "27671c3f-8e50-448d-9edf-2ee4f936188b")
Team.find_or_create_by(id: 9,   certname: 'hitcon', name: "HITCON", address: '10.5.9.2', uuid: "0cdc3fa6-7a20-4436-8f89-b9c7c1402b78")
Team.find_or_create_by(id: 10,  certname: 'blue-lotus', name: "blue-lotus", address: '10.5.10.2', uuid: "93aee048-4b46-4a02-b22e-a9c0ec508a1b")
Team.find_or_create_by(id: 11,  certname: 'hackingforchimac', name: "HackingForChiMac", address: '10.5.11.2', uuid: "35c688ab-50a9-4151-9842-565d92ee9fb1")
Team.find_or_create_by(id: 12,  certname: 'mmibh', name: "(Mostly) Men in Black Hats", address: '10.5.12.2', uuid: "9310fd6d-0e50-48fc-b3ae-9a0df34708f5")
Team.find_or_create_by(id: 13,  certname: 'w3stormz', name: "w3stormz", address: '10.5.13.2', uuid: "0f21dd0b-cd07-458f-95f4-87d0766e9f98")
Team.find_or_create_by(id: 14,  certname: 'mslc', name: "More Smoked Leet Chicken", address: '10.5.14.2', uuid: "345471c1-e5c0-48dc-8238-9ef602588f4e")
Team.find_or_create_by(id: 15,  certname: 'dragonsector', name: "Dragon Sector", address: '10.5.15.2', uuid: "b3de224a-5fde-4b18-ba2c-13dc5223bda4")
Team.find_or_create_by(id: 16,  certname: 'penthackon', name: "[SEWorks]penthackon", address: '10.5.16.2', uuid: "3b800378-cd29-4fa7-b53f-19be63a09768")
Team.find_or_create_by(id: 17,  certname: 'stratum', name: "Stratum Auhuur", address: '10.5.17.2', uuid: "64f88da6-6522-4f7e-87bd-070a5e2d618c")
Team.find_or_create_by(id: 18,  certname: 'gallopsled', name: "Gallopsled", address: '10.5.18.2', uuid: "4048b043-c4cf-44fe-9eff-32b1e2712699")
Team.find_or_create_by(id: 19,  certname: 'balalaikacr3w', name: "BalalaikaCr3w", address: '10.5.19.2', uuid: "a28ad3f5-8841-4a4d-88fe-72a5d9dc81e7")
Team.find_or_create_by(id: 20,  certname: 'binja', name: "binja", address: '10.5.20.2', uuid: "121cc151-3bf3-43b3-9088-b21dd89a0493")

Team.find_or_create_by(id: 21,
                       name: 'Legitimate Business Syndicate', 
                       certname: 'legitbs', 
                       uuid: "deadbeef-84c4-4b55-8cef-d9471caf1f86",
                       address: "10.5.21.2"
                       )

Service.find_or_create_by(name: 'eliza', enabled: true)
Service.find_or_create_by(name: 'wdub')
Service.find_or_create_by(name: 'badge')
Service.find_or_create_by(name: 'justify')
Service.find_or_create_by(name: 'imap', enabled: true)
Service.find_or_create_by(name: 'csniff')

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

Flag.initial_distribution
