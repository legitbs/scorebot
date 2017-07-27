# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.find_or_create_by(id: 1,
                       certname: "ppp",
                       name: "PPP",
                       address: "10.5.1.2",
                       uuid: "1f3787cd-5de8-408f-b341-52e1371f9868")
Team.find_or_create_by(id: 2,
                       certname: "eatsleeppwnrepeat",
                       name: "Eat Sleep Pwn Repeat",
                       address: "10.5.2.2",
                       uuid: "93a0b079-9def-4138-a172-d9265c65d4de")
Team.find_or_create_by(id: 3,
                       certname: "defkor",
                       name: "DEFKOR",
                       address: "10.5.3.2",
                       uuid: "4859a35c-f02c-4ec2-a8b9-5b70a9491379")
Team.find_or_create_by(id: 4,
                       certname: "pasten",
                       name: "pasten",
                       address: "10.5.4.2",
                       uuid: "e281c3c6-b1eb-4793-8224-e812b5422cbd")
Team.find_or_create_by(id: 5,
                       certname: "hitcon",
                       name: "HITCON",
                       address: "10.5.5.2",
                       uuid: "0a3caf54-7169-4eaf-930d-152bcaa5bce0")
Team.find_or_create_by(id: 6,
                       certname: "bushwhackers",
                       name: "Bushwhackers",
                       address: "10.5.6.2",
                       uuid: "d5de2ddb-5027-4beb-afee-8ad08a5dfb6a")
Team.find_or_create_by(id: 7,
                       certname: "koreanbadass",
                       name: "koreanbadass",
                       address: "10.5.7.2",
                       uuid: "e4b41633-5768-41b1-8109-9fbea2a6e495")
Team.find_or_create_by(id: 8,
                       certname: "teadeliverers",
                       name: "Tea Deliverers",
                       address: "10.5.8.2",
                       uuid: "e64ead2d-2c6a-47c7-b507-c46520d2e446")
Team.find_or_create_by(id: 9,
                       certname: "shellphish",
                       name: "Shellphish",
                       address: "10.5.9.2",
                       uuid: "219a3588-241f-4270-85f3-123ca13740bc")
Team.find_or_create_by(id: 10,
                       certname: "aoe",
                       name: "A*0*E",
                       address: "10.5.10.2",
                       uuid: "ce8cf304-1e46-4510-a7e2-0f3bfb37a9c9")
Team.find_or_create_by(id: 11,
                       certname: "hacking4danbi",
                       name: "hacking4danbi",
                       address: "10.5.11.2",
                       uuid: "44d3ced5-578b-4ab6-8cc3-2dc3df390b9c")
Team.find_or_create_by(id: 12,
                       certname: "spamandhex",
                       name: "!SpamAndHex",
                       address: "10.5.12.2",
                       uuid: "4e216a45-c00e-4f2b-a412-d082a5cb16bc")
Team.find_or_create_by(id: 13,
                       certname: "rrr",
                       name: "RRR",
                       address: "10.5.13.2",
                       uuid: "6c470ee8-59c2-42d9-ac41-2e5802d4790f")
Team.find_or_create_by(id: 14,
                       certname: "teamrocket",
                       name: "Team Rocket ☠️",
                       address: "10.5.14.2",
                       uuid: "6cbea353-9c5b-4bac-a8c1-83188c41eb05")
Team.find_or_create_by(id: 15,
                       certname: "labrats",
                       name: "Lab RATs",
                       address: "10.5.15.2",
                       uuid: "9212af88-c9db-40e3-8462-32fc90a64535")


Team.find_or_create_by(id: 16,
                       name: 'Legitimate Business Syndicate',
                       certname: 'legitbs',
                       uuid: "deadbeef-7872-499a-a060-3143de953e28",
                       address: "10.5.16.2"
                      )

regular_services = %w{
rubix
babyecho
forth
babysfirst
bbs
colbert
perplexity
notsosmugmug
untitled4
pppoe
}.map do |service_name|
  Service.find_or_create_by(name: service_name)
end

livectf_services = [].map do |service_name|
  Service.find_or_create_by(name: service_name)
end

Team.find_each do |t|
  (livectf_services + regular_services).each do |s|
    Instance.find_or_create_by team_id: t.id, service_id: s.id
  end
end


Timer.find_or_create_by(name: 'game').
  update_attributes(ending: (Time.zone.parse('28-jul-2017 8pm pdt') + 14.hours))
Timer.find_or_create_by name: 'round'
Timer.
  find_or_create_by(name: 'friday').
  update_attributes(ending: Time.zone.parse('28-jul-2017 8pm pdt'))
Timer.
  find_or_create_by(name: 'saturday').
  update_attributes(ending: Time.zone.parse('29-jul-2017 8pm pdt'))
Timer.
  find_or_create_by(name: 'sunday').
  update_attributes(ending: Time.zone.parse('30-jul-2017 2pm pdt'))

Flag.delete_all

Flag.initial_distribution

# Flag.collect_livectf_flags livectf_services
