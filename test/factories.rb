FactoryGirl.define do
  factory :replacement do
    team nil
    service nil
    round nil
    digest "MyString"
  end
  factory :service do
    name 'atmail'
  end

  factory :team do
    sequence :name
    sequence :certname

    address '10.69.4.20'

    factory :legitbs do
      name 'legitbs'
      uuid 'deadbeef-7872-499a-a060-3143de953e28'
    end
  end

  factory :round do
    factory :current_round do
      created_at(Time.now - 2.minutes)
      ended_at nil
    end
  end

  factory :instance do
    service
    team
    factory :lbs_instance do
      association :team, factory: :legitbs
    end
  end

  factory :token do
    instance
    round
  end

  factory :availability do
    instance
    round
    token

    status 0
    memo 'okay!'

    factory :down_availability do
      status 1
      memo 'fuck!!!'
    end
  end

  factory :redemption do
    team
    round
    token
  end

  factory :capture do
    redemption
    flag
    round
  end

  factory :flag do
    team
    service
  end
end
