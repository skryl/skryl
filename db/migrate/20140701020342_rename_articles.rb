class RenameArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :tag, :string
    rename_table :articles, :links
  end
end
