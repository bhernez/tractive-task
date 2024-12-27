class QueryableCollection
  def initialize(collection)
    @collection = collection
    @where = {}
  end

  def where(where)
    @where.merge!(where)
    self
  end

  def to_a
    @collection.select(&method(:records_filtering))
  end

  def first
    @collection.detect(&method(:records_filtering))
  end

  def last
    @collection.reverse_each.detect(&method(:records_filtering))
  end

  private

  def records_filtering(record)
    @where.symbolize_keys <= record.send(:attributes).symbolize_keys
  end
end