class RenameArticles < ActiveRecord::Migration
  def change
    add_column :articles, :tag, :string
    rename_table :articles, :links
  end
end
