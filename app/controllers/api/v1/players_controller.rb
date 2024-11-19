# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::PlayersController < Api::V1::ApplicationController
    account_load_and_authorize_resource :player, through: :team, through_association: :players

    # GET /api/v1/teams/:team_id/players
    def index
    end

    # GET /api/v1/players/:id
    def show
    end

    # POST /api/v1/teams/:team_id/players
    def create
      if @player.save
        render :show, status: :created, location: [:api, :v1, @player]
      else
        render json: @player.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/players/:id
    def update
      if @player.update(player_params)
        render :show
      else
        render json: @player.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/players/:id
    def destroy
      @player.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def player_params
        strong_params = params.require(:player).permit(
          *permitted_fields,
          :birth_date,
          :nationality,
          :position,
          :height,
          :weight,
          :description,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          skills: [],
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::PlayersController
  end
end
