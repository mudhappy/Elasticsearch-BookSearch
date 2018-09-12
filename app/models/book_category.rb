class BookCategory < ApplicationRecord
  has_many :books

  after_save :index_books_in_elasticsearch

  private

  def index_books_in_elasticsearch
    self.books.find_each do |book|
      book.__elasticsearch__.index_document
    end
  end
end
