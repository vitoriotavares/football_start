require "controllers/api/v1/test"

class Api::V1::AgentsControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @agent = build(:agent, team: @team)
    @other_agents = create_list(:agent, 3)

    @another_agent = create(:agent, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @agent.save
    @another_agent.save

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
  def assert_proper_object_serialization(agent_data)
    # Fetch the agent in question and prepare to compare it's attributes.
    agent = Agent.find(agent_data["id"])

    assert_equal_or_nil agent_data['license_number'], agent.license_number
    assert_equal_or_nil agent_data['years_of_experience'], agent.years_of_experience
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal agent_data["team_id"], agent.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/agents", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    agent_ids_returned = response.parsed_body.map { |agent| agent["id"] }
    assert_includes(agent_ids_returned, @agent.id)

    # But not returning other people's resources.
    assert_not_includes(agent_ids_returned, @other_agents[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/agents/#{@agent.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/agents/#{@agent.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    agent_data = JSON.parse(build(:agent, team: nil).api_attributes.to_json)
    agent_data.except!("id", "team_id", "created_at", "updated_at")
    params[:agent] = agent_data

    post "/api/v1/teams/#{@team.id}/agents", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/agents",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/agents/#{@agent.id}", params: {
      access_token: access_token,
      agent: {
        license_number: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @agent.reload
    assert_equal @agent.license_number, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/agents/#{@agent.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Agent.count", -1) do
      delete "/api/v1/agents/#{@agent.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/agents/#{@another_agent.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
