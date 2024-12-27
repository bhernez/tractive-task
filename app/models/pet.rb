class Pet
  PET_TYPES = %w[Cat Dog].freeze

  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serializers::JSON
  # If ever changed to use `ActiveRecord` then the following module MUST be removed
  include VolatilePet

  attribute :type, :string
  attribute :tracker_type, :string
  attribute :owner_id, :integer
  attribute :in_zone, :boolean # Boolean true - in the zone, false - outside the zone

  before_validation :normalize_type_value

  validates :type, presence: true, inclusion: { in: PET_TYPES }
  validates :owner_id, presence: true

  private

  def normalize_type_value
    self.type = type&.titleize
  end
end

