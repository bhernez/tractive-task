module VolatilePet
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Callbacks
    include InMemoryStore
    include Queryable

    attribute :id, :integer

    define_model_callbacks :initialize, only: :after
    after_initialize :set_default_type

    def initialize(*)
      run_callbacks(:initialize) { super }
    end

    # Using `private_class_method` and `inherited` to mimic abstract class behavior.
    # If ever changed to use `ActiveRecord` then both can be removed and replaced
    # with `self.abstract_class = true`.
    # private_class_method :new

    # def self.inherited(klass)
    #   super
    #   klass.public_class_method :new
    # end

    # A shorthand method to mimic `ActiveRecord` behavior, which comes handy when
    # creating new instances from the subclasses.
    private def set_default_type
      self.type ||= self.model_name
    end
  end
end