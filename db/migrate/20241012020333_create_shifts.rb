class CreateShifts < ActiveRecord::Migration[7.2]
  def change
    create_table :shifts do |t|
      t.references :user
      t.datetime :start_time
      t.datetime :end_time
      t.boolean :acknowledged, default: false
      t.text :notes

      t.timestamps
    end
  end
end
