# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Shift, type: :model do
  describe '#overlap' do 
    context 'when a shift doesnt overlap with any other shift' do 
      let!(:previously_created_shift) { create(:shift, 
        start_time: Time.now.days_ago(-1).change(hour: 12), 
        end_time: Time.now.days_ago(-1).change(hour: 13)) 
      }
      let(:shift) { 
        Shift.new(
          start_time: Time.now.days_ago(-1).change(hour: 15), 
          end_time: Time.now.days_ago(-1).change(hour: 17),
          user_id: create(:user).id
        ) 
      }

      it 'should save without issues' do 
        expect(shift.save).to be_truthy
      end
    end

    context 'when 2 shifts overlaps' do 
      let!(:previously_created_shift) { create(:shift, 
        start_time: Time.now.days_ago(-1).change(hour: 12), 
        end_time: Time.now.days_ago(-1).change(hour: 20)) 
      }
      let(:shift) { 
        Shift.new(
          start_time: Time.now.days_ago(-1).change(hour: 19), 
          end_time: Time.now.days_ago(-1).change(hour: 23),
          user_id: create(:user).id
        ) 
      }

      it 'shouldnt be able to save' do 
        expect(shift.save).to be_falsey
      end

      it 'should return validation errors' do 
        shift.save
        expect(shift.errors.messages).to eq({:dates => ["overlap with other shift"]})
      end
    end
  end
end
