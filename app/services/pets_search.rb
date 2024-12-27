class PetsSearch
  class QueryParamError < StandardError; end

  # As this service is used also by the controller, some validations to avoid querying the whole database might be needed.
  # The `validate` parameter is used to skip validations when the service is used internally.
  def initialize(params, validate: true)
    @params = params
    @validate = validate
  end

  def run
    if @validate
      validate_has_params!
      validate_type!
      validate_lost_tracker!
    end

    scope.where(queryable_params).to_a
  end

  private

  def scope
    if klass == Cat && @params[:lost_tracker].present?
      Cat.by_tracker_status(lost: @params[:lost_tracker])
    end

    klass.all
  end

  def queryable_params
    @params.slice(:tracker_type, :owner_id, :in_zone)
  end

  def validate_has_params!
    raise QueryParamError, "No parameters provided" if @params.empty?
  end

  def validate_type!
    raise QueryParamError, "Invalid type: #{@params[:type]}" unless Pet::PET_TYPES.include?(klass.to_s)
  end

  def validate_lost_tracker!
    if !@params[:lost_tracker].nil? && klass != Cat
      raise QueryParamError, "Invalid `lost_tracker` attribute for type '#{@params[:type]}'"
    end
  end

  def klass
    @klass ||= @params[:type]&.safe_constantize || Pet
  rescue NameError
    raise QueryParamError, "Invalid type: #{@params[:type]}"
  end
end