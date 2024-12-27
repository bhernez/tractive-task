module InMemoryStore
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Callbacks

    define_model_callbacks :save, :destroy

    class_attribute :store, instance_writer: false, default: Set.new
    after_save { self.class.store << self }

    def save
      run_callbacks(:save) {
        self.id ||= self.class.store.size + 1
        self
      }
    end

    def destroy
      run_callbacks(:destroy) {
        self.class.store.delete(self)
      }
    end
  end
end