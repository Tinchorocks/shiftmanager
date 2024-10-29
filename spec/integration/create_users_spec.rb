# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Flow for User creation', type: :request do
  let!(:scheduler) { create(:user, :scheduler)}
  let!(:employee) { create(:user, :employee)}

  it 'creates successfully a User' do 
    sign_in(scheduler)
    
    get '/admin/users'
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.to_s).to include(employee.name) # scheduler should see employees
    
    get '/admin/users/new'
    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.to_s).to include('New User')

    expect(User.count).to eq(2)
    post '/admin/users', params: {
      user: {
        email: 'testuser@test.com',
        password: 'asd123',
        name: 'Test User',
      },
      roles: :employee
    }
    response.should redirect_to(admin_users_path)
    expect(User.count).to eq(3)
  end
end