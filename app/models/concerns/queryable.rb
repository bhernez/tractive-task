module Queryable
  extend ActiveSupport::Concern
  extend ActiveSupport::Delegation

  class_methods do
    delegate :where, :to_a, :first, :last, to: :queryable_collection, allow_nil: true

    def all
      queryable_collection
    end

    def queryable_collection
      default_scope.presence || ::QueryableCollection.new(store)
    end

    def default_scope(&block)
      @default_scope = block.call if block_given?
      @default_scope
    end
  end
end