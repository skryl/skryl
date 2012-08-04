class CreateSleepRecords < ActiveRecord::Migration
  def change
    create_table :sleep_records do |t|
      t.timestamps
      t.datetime :bed_time                     ,:null => false
      t.datetime :rise_time                    ,:null => false
      t.date :start_date                       ,:null => false 
      t.integer :awakenings                    ,:null => false 
      t.integer :awakenings_zq_points          ,:null => false 
      t.integer :time_in_deep                  ,:null => false 
      t.integer :time_in_deep_percentage       ,:null => false
      t.integer :time_in_deep_zq_points        ,:null => false
      t.integer :time_in_light                 ,:null => false
      t.integer :time_in_light_percentage      ,:null => false
      t.integer :time_in_rem                   ,:null => false
      t.integer :time_in_rem_percentage        ,:null => false
      t.integer :time_in_rem_zq_points         ,:null => false
      t.integer :time_in_wake                  ,:null => false
      t.integer :time_in_wake_percentage       ,:null => false
      t.integer :time_in_wake_zq_points        ,:null => false
      t.integer :time_to_z                     ,:null => false
      t.integer :total_z                       ,:null => false
      t.integer :total_z_zq_points             ,:null => false
      t.integer :zq                            ,:null => false
      t.string  :sleep_graph                   ,:null => false
      t.string  :sleep_graph_start_time        ,:null => false
    end
  end
end
