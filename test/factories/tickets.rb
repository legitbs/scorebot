# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    team nil
    body "MyText"
    resolved_at "2014-06-24 17:07:37"
  end
end
