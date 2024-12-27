class PetsController < ApplicationController
  def create
    @pet = build_pet(pet_creation_params)

    if @pet.valid? && @pet.save
      render json: @pet, status: :created
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  def show
    @pet = fetch_pet

    if @pet.present?
      render json: @pet
    else
      head :not_found
    end
  end

  def index
    pets_search = PetsSearch.new(query_pet_params)
    render json: pets_search.run
  rescue PetsSearch::QueryParamError => e
    render json: { error: e.message }, status: :bad_request
  end

  def stats
    render json: PetsStats.new.run
  end

  def destroy
    @pet = Pet.where(id: params[:id].to_i).first

    if @pet.present?
      @pet.destroy
      render json: @pet
    else
      head :not_found
    end
  end

  def update
    @pet = fetch_pet

    if @pet.present?
      @pet.assign_attributes(pet_update_params)
      render json: @pet
    else
      head :not_found
    end
  end

  private

  def pet_creation_params
    params.require(:pet).permit(:type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end

  def query_pet_params
    params.permit(:type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
  end

  def pet_update_params
    params.require(:pet).permit(:in_zone, :lost_tracker, :tracker_type)
  end

  def validate_pet_type
    return if Pet::PET_TYPES.include?(pet_params[:type])

    render json: { errors: "Invalid type" }, status: :unprocessable_entity
  end

  def build_pet(pet_params)
    type = pet_params.delete(:type)
    klass = type&.safe_constantize || Pet
    klass.new(pet_params)
  end

  def fetch_pet
    pet = Pet.where(id: params[:id].to_i).first
    return if pet.nil?
    pet.type.constantize.new(pet.attributes)
  end
end
