class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.timestamps
      t.integer  :activity_id                  ,:null => false
      t.string   :activity_type                ,:null => false
      t.datetime :start_time                   ,:null => false
      t.string   :status
      t.boolean  :gps
      t.integer  :latitude
      t.integer  :longitude
      t.boolean  :heartrate
      t.string   :device_type
      t.float    :duration                     ,:null => false
      t.float    :distance                     ,:null => false
      t.integer  :calories                     ,:null => false
      t.text     :gps_data
      t.text     :hr_data
      t.text     :speed_data
    end
  end
end
