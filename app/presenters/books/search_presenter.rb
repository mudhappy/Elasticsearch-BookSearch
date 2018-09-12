module Books
  class SearchPresenter
    include SortResponse

    def initialize(books_search, search_params={})
      @books = books_search
      @search_params = search_params
    end

    def total_count
      @books.response.hits.total
    end

    def page_ranges
      if Book.count == total_count
        sort_range_by(@books, 'buckets')
      else
        @search_params[:gte] = 0
        @search_params[:lte] = 9999
        sort_range_by(BookQuery.search(@search_params), 'buckets')
      end
    end
  end
end
