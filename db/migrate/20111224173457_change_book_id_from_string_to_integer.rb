class ChangeBookIdFromStringToInteger < ActiveRecord::Migration[5.1]
  def change
    change_table :book_authors do |t|
      t.change :book_id, :integer
    end
  end
end
