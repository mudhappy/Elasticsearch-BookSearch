class Book < ApplicationRecord
  # Associations
  belongs_to :author
  belongs_to :book_category

  # Callbacks
  after_save :index_books_in_elasticsearch

  # Auxiliars
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # Elastic Methods
  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :name, :description, :isbn, :published_at, :pages],
      include: {
        author: { only: [:first_name, :last_name] },
        book_category: { only: [:title] }
      }
    )
  end

  # Kaminari per_page
  def self.per_page
    3
  end

  private

  def index_books_in_elasticsearch
    self.__elasticsearch__.index_document
  end

end
