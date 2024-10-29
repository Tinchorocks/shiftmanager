# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_user = User.find_by(email: 'martinmb96@gmail.com')

unless admin_user 
  admin = User.create!(email: 'martinmb96@gmail.com', password: 'admin123', name: 'Martin (Admin)')
  admin.add_role :admin
  
  scheduler = User.create!(email: 'scheduler@gmail.com', password: 'asd123', name: 'John Doe (Scheduler)')
  scheduler.add_role :scheduler
  
  employee = User.create!(email: 'employee@gmail.com', password: 'asd123', name: 'John Doe (Employee)', employee_id: 'EMP12')
  employee.add_role :employee

  employee.shifts.create!(
    start_time: Time.now.days_ago(-1).change(hour: 12),
    end_time:   Time.now.days_ago(-1).change(hour: 13),
    notes: 'Some notes on the Shift',
  )

  employee.shifts.create!(
    start_time: Time.now.days_ago(-2).change(hour: 15),
    end_time:   Time.now.days_ago(-2).change(hour: 20),
    notes: 'Some notes on the Shift',
  )
end