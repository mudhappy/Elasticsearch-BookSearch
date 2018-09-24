class AddBookCategoryToBook < ActiveRecord::Migration[5.2]
  def change
    add_reference :books, :book_category, foreign_key: true
  end
end
