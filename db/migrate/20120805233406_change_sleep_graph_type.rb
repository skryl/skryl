class ChangeSleepGraphType < ActiveRecord::Migration[5.1]
  def up
    change_column :sleep_records, :sleep_graph, :text
  end

  def down
  end
end
