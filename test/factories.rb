FactoryGirl.define do
  factory :service do
    name 'service'
  end
  
  factory :team do
    sequence :name
    sequence :certname

    address '10.69.4.20'
  end

  factory :round do
    
  end

  factory :instance do
    service
    team
  end

  factory :token do
    instance
    round
  end

  factory :availability do
    instance
    round

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
  end

  factory :flag do
    team
  end
end
