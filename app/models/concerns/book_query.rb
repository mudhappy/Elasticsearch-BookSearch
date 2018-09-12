module BookQuery
  def self.search(search_params)
    search_hash = {
      query: custom_query(search_params),
      aggs: aggregations
    }

    search_hash[:from] = custom_from(
      search_params[:page],
      Book.per_page
    )
    search_hash[:size] = Book.per_page

    Book.search(search_hash)
  end

  private

  # Make a custom search
  # Query
  def self.custom_query(search_params)
    custom_hash = {
      bool: {
        must: []
      }
    }

    multi_match = {
      multi_match: {
        query: search_params[:query]
      }
    }

    match_all = {
      match_all: {}
    }

    custom_hash[:bool][:must] << match_all
    custom_hash[:bool][:must] << page_ranges(search_params[:gte], search_params[:lte])
    custom_hash[:bool][:must] << multi_match unless search_params[:query]==""
    custom_hash[:bool][:must] << match("book_category.title", search_params[:book_category]) unless search_params[:book_category]==""

    custom_hash
  end

  # Match Query
  def self.match(key, value)
    {
      match: { "#{key}": "#{value}" }
    }
  end

  # Range
  def self.page_ranges(gte, lte)
    {
      range: {
        pages: {
          gte: gte,
          lte: lte
        }
      }
    }
  end

  # Aggregations
  def self.aggregations
    {
      page_ranges: {
        range: {
          field: 'pages',
          ranges: [
            {key: 'All', from: 0, to: 9999},
            {key: '0-100 pages', from: 0, to: 100},
            {key: '101-300 pages', from: 101, to: 300},
            {key: '301+ pages', from: 301, to: 9999},
          ]
        }
      }
    }
  end

  # Kaminari book records for current page
  def self.custom_from(page, per_page)
    (page.to_i-1) * per_page.to_i
  end

end
