# This class was mainly kept for consistency given `Cat` model entity exists.
class Dog < Pet
  TRACKER_TYPES = %w[small medium big].freeze
  # If ever changed to use `ActiveRecord` the following line COULD be removed
  # as by default `ActiveRecord` does this scope
  default_scope { where(type: model_name) }

  validates :tracker_type, presence: true, inclusion: { in: TRACKER_TYPES }
end