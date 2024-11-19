# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::AgenciesController < Api::V1::ApplicationController
    account_load_and_authorize_resource :agency, through: :team, through_association: :agencies

    # GET /api/v1/teams/:team_id/agencies
    def index
    end

    # GET /api/v1/agencies/:id
    def show
    end

    # POST /api/v1/teams/:team_id/agencies
    def create
      if @agency.save
        render :show, status: :created, location: [:api, :v1, @agency]
      else
        render json: @agency.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/agencies/:id
    def update
      if @agency.update(agency_params)
        render :show
      else
        render json: @agency.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/agencies/:id
    def destroy
      @agency.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def agency_params
        strong_params = params.require(:agency).permit(
          *permitted_fields,
          :name,
          :location,
          :position,
          :contact_info,
          :license_number,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::AgenciesController
  end
end
