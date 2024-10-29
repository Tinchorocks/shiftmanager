FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:email, 'A') { |n| "email_#{n}@example.com"}
    sequence(:name, 'A') { |n| "Test User #{n}" }
    sequence(:employee_id, 'A') { |n| "TEST#{n}" }
    password { "[omitted]" }
    
    trait :admin do 
      after :create do |user|
        user.add_role(:admin)
      end
    end 
    
    trait :scheduler do 
      after :create do |user|
        user.add_role(:scheduler)
      end
    end 
    
    trait :employee do 
      sequence(:employee_id, '1') { |n| "Employee #{n}" }

      after :create do |user|
        user.add_role(:employee)
      end
    end 

    trait :with_shifts do 
      after :create do |user|
        create(:shift, user: user, start_time: Time.now.days_ago(-2).change(hour: 10), end_time: Time.now.days_ago(-1).change(hour: 12))
        create(:shift, user: user, start_time: Time.now.days_ago(-2).change(hour: 14), end_time: Time.now.days_ago(-1).change(hour: 16))
        create(:shift, user: user, start_time: Time.now.days_ago(-2).change(hour: 18), end_time: Time.now.days_ago(-1).change(hour: 19))
      end
    end
  end

  factory :invalid_employee_user, class: 'User' do
    sequence(:email, 'A') { |n| "email_#{n}@example.com"}
    sequence(:name, 'A') { |n| "Test User #{n}" }
    password { "[omitted]" }

    after :create do |user|
      user.add_role(:employee)
    end
  end
end