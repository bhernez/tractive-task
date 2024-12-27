require "test_helper"

class PetsControllerTest < ActionDispatch::IntegrationTest
  test "query for a pet" do
    pet = Dog.new(tracker_type: "small", owner_id: 1, in_zone: true).save
    get pet_url(id: pet.id), as: :json
    assert_response :success
  end

  test "query for a pet that does not exist" do
    get pet_url(id: 0), as: :json
    assert_response :not_found
  end

  test "query for pets without parameters" do
    get pets_url, as: :json
    assert_response :bad_request
  end

  test "create a pet" do
    assert_difference("Pet.to_a.size") do
      post pets_url, params: { pet: { type: "Dog", tracker_type: :small, owner_id: 1, in_zone: true } }, as: :json
    end

    assert_response :created
  end

  test "create a cat" do
    assert_difference("Cat.to_a.size") do
      post pets_url, params: { pet: { type: "Cat", tracker_type: :small, owner_id: 1, in_zone: true, lost_tracker: false } }, as: :json
    end

    assert_response :created
  end

  test "create a pet with invalid `type` parameter" do
    assert_no_difference("Pet.to_a.size") do
      post pets_url, params: { pet: { type: "Parrot", tracker_type: :small, owner_id: 1, in_zone: true } }, as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.parsed_body.keys, "type"
  end

  test "create a pet with invalid `tracker_type` parameter" do
    assert_no_difference("Pet.to_a.size") do
      post pets_url, params: { pet: { type: "Dog", tracker_type: :xsmall, owner_id: 1, in_zone: true } }, as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.parsed_body.keys, "tracker_type"
  end

  test "create a pet with invalid `owner_id` parameter" do
    assert_no_difference("Pet.to_a.size") do
      post pets_url, params: { pet: { type: "Cat", tracker_type: :small, owner_id: nil, in_zone: true } }, as: :json
    end

    assert_response :unprocessable_entity
    assert_includes response.parsed_body.keys, "owner_id"
  end

  test "query for pets with query parameters" do
    get pets_url(type: "Dog", owner_id: 1, in_zone: true), as: :json
    assert_response :success
  end

  test "query for pets with invalid `type` parameter" do
    get pets_url(type: "Parrot"), as: :json
    assert_response :bad_request
    assert_includes response.parsed_body["error"], "Invalid type"
  end

  test "query for pets with invalid `lost_tracker` parameter" do
    get pets_url(type: "Dog", tracker_type: :small, owner_id: 1, in_zone: true, lost_tracker: false), as: :json
    assert_response :bad_request
    assert_includes response.parsed_body["error"], "Invalid `lost_tracker` attribute"
  end

  test "update a pet" do
    pet = Dog.new(tracker_type: "small", owner_id: 1, in_zone: true).save

    patch pet_url(id: pet.id), params: { pet: { in_zone: false } }, as: :json

    assert_response :success
    assert_equal false, response.parsed_body["in_zone"]
  end

  test "update a pet that does not exist" do
    patch pet_url(id: 0), params: { pet: { in_zone: false } }, as: :json
    assert_response :not_found
  end

  test "delete a pet" do
    pet = Dog.new(tracker_type: "small", owner_id: 1, in_zone: true).save

    delete pet_url(id: pet.id), as: :json

    assert_response :success
  end

  test "delete a pet that does not exist" do
    delete pet_url(id: 0), as: :json
    assert_response :not_found
  end

  test "get stats" do
    get stats_pets_url, as: :json
    assert_response :success
  end
end
