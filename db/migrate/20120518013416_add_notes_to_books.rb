class AddNotesToBooks < ActiveRecord::Migration[5.1]
  def up
    add_column :books, :notes_url, :string
  end

  def down
    remove_column :books, :notes_url
  end
end
