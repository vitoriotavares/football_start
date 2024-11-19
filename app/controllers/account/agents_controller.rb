class Account::AgentsController < Account::ApplicationController
  account_load_and_authorize_resource :agent, through: :team, through_association: :agents

  # GET /account/teams/:team_id/agents
  # GET /account/teams/:team_id/agents.json
  def index
    delegate_json_to_api
  end

  # GET /account/agents/:id
  # GET /account/agents/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/agents/new
  def new
  end

  # GET /account/agents/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/agents
  # POST /account/teams/:team_id/agents.json
  def create
    respond_to do |format|
      if @agent.save
        format.html { redirect_to [:account, @agent], notice: I18n.t("agents.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @agent] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/agents/:id
  # PATCH/PUT /account/agents/:id.json
  def update
    respond_to do |format|
      if @agent.update(agent_params)
        format.html { redirect_to [:account, @agent], notice: I18n.t("agents.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @agent] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/agents/:id
  # DELETE /account/agents/:id.json
  def destroy
    @agent.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :agents], notice: I18n.t("agents.notifications.destroyed") }
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
