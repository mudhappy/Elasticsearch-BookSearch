class Book < ApplicationRecord
  belongs_to :author

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks


  def self.search(query)
    self.search({
      query: {
        match: {
          name: query
        }
      }
    })
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :name, :isbn, :published_at, :pages],
      include: {
        author: {
          only: [:first_name, :last_name]
        }
      }
    )
  end
end
