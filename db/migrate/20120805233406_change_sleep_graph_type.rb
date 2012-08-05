class ChangeSleepGraphType < ActiveRecord::Migration
  def up
    change_column :sleep_records, :sleep_graph, :text
  end

  def down
  end
end
