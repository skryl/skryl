class MakeNumPagesOptional < ActiveRecord::Migration[5.1]
  def up
    change_column :books, :num_pages, :integer, :null => true
  end

  def down
  end
end
