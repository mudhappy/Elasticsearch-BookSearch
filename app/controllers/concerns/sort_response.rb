module SortResponse
  def sort_range_by(search, type='buckets', key='key')
    search.response.to_hash['aggregations']['page_ranges'][type].sort_by{ |x| x[key] }.reverse
  end
end
