class RemoveSleepTable < ActiveRecord::Migration
  def change
    drop_table :sleep_records
  end
end
