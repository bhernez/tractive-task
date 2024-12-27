class PetsStats
  def run
    stats = {}

    fetch_pets.then do |pets|
      stats[:total] = pets.count
      stats[:in_zone] = in_zone_stats(pets)
    end

    stats
  end

  private

  def fetch_pets
    default_query = { }
    PetsSearch.new(default_query, validate: false).run
  end

  def in_zone_stats(pets)
    group_by_in_zone(pets).transform_values do |pets|
      group_by_type(pets).transform_values do |pets|
        group_by_tracker_type(pets).transform_values(&:count)
      end
    end
  end

  def group_by_in_zone(pets)
    pets.group_by(&:in_zone)
  end

  def group_by_type(pets)

    pets.group_by(&:type)
  end

  def group_by_tracker_type(pets)
    pets.group_by(&:tracker_type)
  end
end