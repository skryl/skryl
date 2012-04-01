class MakeNumPagesOptional < ActiveRecord::Migration
  def up
    change_column :books, :num_pages, :integer, :null => true
  end

  def down
  end
end
