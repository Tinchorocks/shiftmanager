FactoryBot.define do
  factory :shift, class: 'Shift' do
    sequence(:start_time,(0..23).cycle) { |n| Time.now.days_ago(-1).change(hour: n) } # tomorrow at some hour
    sequence(:end_time, (1..24).cycle) { |n| Time.now.days_ago(-1).change(hour: n)  } # tomorrow 1 hour later than start_time
    acknowledged { false }
    notes { 'Test Notes' }
    user { create(:user, :employee) }
  end
end
