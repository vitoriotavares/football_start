require "controllers/api/v1/test"

class Api::V1::AgenciesControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @agency = build(:agency, team: @team)
    @other_agencies = create_list(:agency, 3)

    @another_agency = create(:agency, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @agency.save
    @another_agency.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  def teardown
    super
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(agency_data)
    # Fetch the agency in question and prepare to compare it's attributes.
    agency = Agency.find(agency_data["id"])

    assert_equal_or_nil agency_data['name'], agency.name
    assert_equal_or_nil agency_data['location'], agency.location
    assert_equal_or_nil agency_data['position'], agency.position
    assert_equal_or_nil agency_data['contact_info'], agency.contact_info
    assert_equal_or_nil agency_data['license_number'], agency.license_number
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal agency_data["team_id"], agency.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/agencies", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    agency_ids_returned = response.parsed_body.map { |agency| agency["id"] }
    assert_includes(agency_ids_returned, @agency.id)

    # But not returning other people's resources.
    assert_not_includes(agency_ids_returned, @other_agencies[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/agencies/#{@agency.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/agencies/#{@agency.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    agency_data = JSON.parse(build(:agency, team: nil).api_attributes.to_json)
    agency_data.except!("id", "team_id", "created_at", "updated_at")
    params[:agency] = agency_data

    post "/api/v1/teams/#{@team.id}/agencies", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/agencies",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/agencies/#{@agency.id}", params: {
      access_token: access_token,
      agency: {
        name: 'Alternative String Value',
        location: 'Alternative String Value',
        position: 'Alternative String Value',
        contact_info: 'Alternative String Value',
        license_number: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @agency.reload
    assert_equal @agency.name, 'Alternative String Value'
    assert_equal @agency.location, 'Alternative String Value'
    assert_equal @agency.position, 'Alternative String Value'
    assert_equal @agency.contact_info, 'Alternative String Value'
    assert_equal @agency.license_number, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/agencies/#{@agency.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Agency.count", -1) do
      delete "/api/v1/agencies/#{@agency.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/agencies/#{@another_agency.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
