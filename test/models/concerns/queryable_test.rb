require "test_helper"
require "active_support/testing/method_call_assertions"
class QueryableTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::MethodCallAssertions

  self.test_order = :sorted
  class Dummy
    include ActiveModel::Model
    include Queryable
    attr_accessor :id, :flag

    def self.store
      []
    end
  end

  test "default_scope sets default scope" do
    assert_changes -> { Dummy.default_scope }, from: nil, to: QueryableCollection do
      Dummy.default_scope { Dummy.where(flag: true) }
    end
  end

  test "all returns queryable_collection" do
    assert_called(Dummy, :queryable_collection) do
      Dummy.all
    end
  end

  test "first delegates to queryable_collection" do
    assert_called(Dummy, :queryable_collection) do
      Dummy.first
    end
  end
end