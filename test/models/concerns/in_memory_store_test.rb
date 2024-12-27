require 'test_helper'

class InMemoryStoreTest < ActiveSupport::TestCase
  class Dummy
    include ActiveModel::Model
    include InMemoryStore

    attr_accessor :id
  end

  test 'should have a store' do
    assert_instance_of Set, Dummy.store
  end

  test 'should not be part of the store after initialization' do
    dummy = Dummy.new
    assert_not_includes Dummy.store, dummy
  end

  test 'should record be included in store after saving' do
    dummy = Dummy.new
    dummy.save
    assert_includes Dummy.store, dummy
  end

  test 'should not be part of the store after destroying' do
    dummy = Dummy.new
    dummy.save
    dummy.destroy
    assert_not_includes Dummy.store, dummy
  end
end
