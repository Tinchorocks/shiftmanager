class Shift < ApplicationRecord
  belongs_to :user

  validates :start_time, :end_time, presence: true, overlap: { 
    message_title: "dates",
    message_content: "overlap with other shift" 
  }
end
