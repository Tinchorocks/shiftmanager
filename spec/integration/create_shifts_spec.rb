# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flow for Shift creation', type: :request do
  let!(:scheduler) { create(:user, :scheduler)}
  let!(:employee) { create(:user, :employee)}
  let!(:shift) { create(:shift, user: employee)}

  it 'creates successfully a Shift' do 
    sign_in(scheduler)
    
    get '/shifts'
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.to_s).to include(employee.name) # scheduler should see employees
    
    get '/shifts/new'
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.to_s).to include('New Shift')

    expect(employee.shifts.count).to eq(1)
    post '/shifts', params: {
      shift: {
        start_time: Time.now.days_ago(-2).change(hour: 20), # Tomorrow at 12
        end_time: Time.now.days_ago(-3).change(hour: 23), # Tomorrow at 13
        acknowledged: false,
        notes: 'Test Notes.',
        user_id: employee.id
      }
    }
    response.should redirect_to(shifts_path)
    expect(employee.shifts.count).to eq(2)
  end
end