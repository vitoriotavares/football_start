class Account::AgenciesController < Account::ApplicationController
  account_load_and_authorize_resource :agency, through: :team, through_association: :agencies

  # GET /account/teams/:team_id/agencies
  # GET /account/teams/:team_id/agencies.json
  def index
    delegate_json_to_api
  end

  # GET /account/agencies/:id
  # GET /account/agencies/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/agencies/new
  def new
  end

  # GET /account/agencies/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/agencies
  # POST /account/teams/:team_id/agencies.json
  def create
    respond_to do |format|
      if @agency.save
        format.html { redirect_to [:account, @agency], notice: I18n.t("agencies.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @agency] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/agencies/:id
  # PATCH/PUT /account/agencies/:id.json
  def update
    respond_to do |format|
      if @agency.update(agency_params)
        format.html { redirect_to [:account, @agency], notice: I18n.t("agencies.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @agency] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/agencies/:id
  # DELETE /account/agencies/:id.json
  def destroy
    @agency.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :agencies], notice: I18n.t("agencies.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
