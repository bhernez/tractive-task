class Cat < Pet
  TRACKER_TYPES = %w[small big].freeze

  # If ever changed to use `ActiveRecord` the following must be changed to either:
  # - A column in a specific `cats` table.
  # - An accessor in a `json` (serialized) column in the `pets` table.
  attribute :lost_tracker, :boolean # Boolean true - tracker lost, false - tracker on cat

  # If ever changed to use `ActiveRecord` the following line COULD be removed
  # as by default `ActiveRecord` does this scope already.
  default_scope { where(type: model_name) }

  validates :tracker_type, presence: true, inclusion: { in: TRACKER_TYPES }

  # Querying by this value is probably the biggest change because the query will change
  # depending on the DB chosen.
  def self.by_tracker_status(lost: false)
    where(lost_tracker: lost)
  end
end