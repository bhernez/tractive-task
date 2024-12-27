# This is just for testing purposes, so we can have some data to query
# If we ever use `ActiveRecord` in the future, we can remove this initializer
# and move the logic a `db/seeds` file.

Rails.application.config.after_initialize do
  10.times do
    [Dog, Cat].sample.then { |klass|
      klass.new(
        in_zone: [true, false].sample,
        owner_id: rand(10),
        tracker_type: klass::TRACKER_TYPES.sample
      ).save
    }
  end
end