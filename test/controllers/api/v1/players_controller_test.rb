require "controllers/api/v1/test"

class Api::V1::PlayersControllerTest < Api::Test
  def setup
    # See `test/controllers/api/test.rb` for common set up for API tests.
    super

    @player = build(:player, team: @team)
    @other_players = create_list(:player, 3)

    @another_player = create(:player, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @player.save
    @another_player.save

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
  def assert_proper_object_serialization(player_data)
    # Fetch the player in question and prepare to compare it's attributes.
    player = Player.find(player_data["id"])

    assert_equal_or_nil Date.parse(player_data['birth_date']), player.birth_date
    assert_equal_or_nil player_data['nationality'], player.nationality
    assert_equal_or_nil player_data['position'], player.position
    assert_equal_or_nil player_data['height'], player.height
    assert_equal_or_nil player_data['weight'], player.weight
    assert_equal_or_nil player_data['skills'], player.skills
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal player_data["team_id"], player.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/players", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    player_ids_returned = response.parsed_body.map { |player| player["id"] }
    assert_includes(player_ids_returned, @player.id)

    # But not returning other people's resources.
    assert_not_includes(player_ids_returned, @other_players[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/players/#{@player.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/players/#{@player.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    player_data = JSON.parse(build(:player, team: nil).api_attributes.to_json)
    player_data.except!("id", "team_id", "created_at", "updated_at")
    params[:player] = player_data

    post "/api/v1/teams/#{@team.id}/players", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/players",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/players/#{@player.id}", params: {
      access_token: access_token,
      player: {
        nationality: 'Alternative String Value',
        position: 'Alternative String Value',
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @player.reload
    assert_equal @player.nationality, 'Alternative String Value'
    assert_equal @player.position, 'Alternative String Value'
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/players/#{@player.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Player.count", -1) do
      delete "/api/v1/players/#{@player.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/players/#{@another_player.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
