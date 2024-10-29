# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:unauthorized_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:scheduler) { create(:user, :scheduler) }
  let(:employee) { create(:user, :employee) }

  describe '#can?' do 
    it 'should return true if a user has permissions' do 
      expect(unauthorized_user.can? :read, unauthorized_user).to be_falsey 
      expect(admin.can? :read, admin).to be_truthy 
      expect(admin.can? :read, employee).to be_truthy 
      expect(scheduler.can? :read, employee).to be_truthy 
      expect(employee.can? :read, employee).to be_truthy 
      expect(employee.can? :read, scheduler).to be_falsey
    end
  end
  
  describe '#cannot?' do 
    it 'should return true if a user doesnt have permissions' do 
      expect(unauthorized_user.cannot? :read, unauthorized_user).to be_truthy
      expect(admin.cannot? :read, admin).to be_falsey 
      expect(admin.cannot? :read, employee).to be_falsey 
      expect(scheduler.cannot? :read, employee).to be_falsey 
      expect(employee.cannot? :read, employee).to be_falsey
      expect(employee.cannot? :read, scheduler).to be_truthy 
    end
  end

  describe '#is_employee?' do 
    context 'when user doesnt have an Employee ID' do 
      context 'when user is an employee' do 
        let(:user) { create(:invalid_employee_user) }

        it 'shouldnt be valid' do 
          expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'should return an error message' do 
          user.save
          expect(user.errors.messages).to eq({:employee_id=>["is required"]}) 
        end

        context 'when updated with an Employee ID' do 
          it 'should be valid' do 
            user.employee_id = 'Test'
            expect { user.save! }.not_to raise_error
          end
        end
      end
    end

    context 'when user isnt an employee' do 
      let(:user) { create(:user, :scheduler) }

      it 'should be valid' do 
        user.employee_id = 'Test'
        expect { user.save! }.not_to raise_error
      end
    end
  end
end
