class Account::PlayersController < Account::ApplicationController
  account_load_and_authorize_resource :player, through: :team, through_association: :players

  # GET /account/teams/:team_id/players
  # GET /account/teams/:team_id/players.json
  def index
    delegate_json_to_api
  end

  # GET /account/players/:id
  # GET /account/players/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/players/new
  def new
  end

  # GET /account/players/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/players
  # POST /account/teams/:team_id/players.json
  def create
    respond_to do |format|
      if @player.save
        format.html { redirect_to [:account, @player], notice: I18n.t("players.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @player] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/players/:id
  # PATCH/PUT /account/players/:id.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to [:account, @player], notice: I18n.t("players.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @player] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/players/:id
  # DELETE /account/players/:id.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :players], notice: I18n.t("players.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    assign_date(strong_params, :birth_date)
    assign_checkboxes(strong_params, :skills)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
