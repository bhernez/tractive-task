require "test_helper"

class QueryableCollectionTest < ActiveSupport::TestCase

  Dummy = Struct.new(:id) do
    def attributes
      { id: id }
    end
  end

  test 'should return all records when no query is given' do
    collection = QueryableCollection.new(records)
    assert_equal records, collection.to_a
  end

  test 'should return only the records that match the query' do
    collection = QueryableCollection.new(records)
    assert_equal [Dummy.new(1)], collection.where(id: 1).to_a
  end

  test 'should return the first record that matches the query' do
    collection = QueryableCollection.new(records)
    assert_equal Dummy.new(1), collection.where(id: 1).first
  end

  test 'should return the last record that matches the query' do
    collection = QueryableCollection.new(records)
    assert_equal Dummy.new(3), collection.where(id: 3).last
  end

  private

  def records
    [Dummy.new(1), Dummy.new(2), Dummy.new(3)]
  end

end