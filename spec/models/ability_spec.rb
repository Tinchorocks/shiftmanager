# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  context 'when there isnt user' do 
    let(:ability) { described_class.new(nil) }

    it 'should have public permissions' do 
      expect(ability.cannot? :manage, User).to be true
      expect(ability.cannot? :manage, Shift).to be true
      expect(ability.permissions[:can]).to be_empty
    end
  end

  describe 'user' do
    context 'when doesnt have any role' do 
      let(:user) { create(:user) }
      let(:ability) { described_class.new(user) }
      
      it 'should have public permissions' do 
        expect(ability.cannot? :manage, User).to be true
        expect(ability.cannot? :manage, Shift).to be true
        expect(ability.permissions[:can]).to be_empty
      end
    end

    context 'when role is :admin' do 
      let(:user) { create(:user, :admin) }
      let(:ability) { described_class.new(user) }

      it 'should have admin permissions' do 
        expect(ability.can? :manage, :all).to be true
        expect(ability.permissions[:cannot]).to be_empty
      end
    end

    context 'when role is :scheduler' do 
      let(:user) { create(:user, :scheduler) }
      let(:ability) { described_class.new(user) }

      it 'should be able to manage any User' do 
        expect(ability.can? :manage, User).to be true
      end
      
      it 'should be able to manage any Shift' do 
        expect(ability.can? :manage, Shift).to be true
      end
    end

    context 'when role is :employee' do 
      let(:user) { create(:user, :employee, :with_shifts) }
      let(:another_user) { create(:user, :employee, :with_shifts) }
      let(:ability) { described_class.new(user) }

      it 'should be able to read itself' do 
        expect(ability.can? :read, user).to be true
      end
      
      it 'should be able to read related Shift' do 
        expect(ability.can? :read, user.shifts.first).to be true
      end

      it 'should not be able to read any User' do 
        expect(ability.cannot? :read, another_user).to be true
      end
      
      it 'should not be able to read any Shift' do 
        expect(ability.cannot? :read, another_user.shifts.first).to be true
      end
    end
  end
end
