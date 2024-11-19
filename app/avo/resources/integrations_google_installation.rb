class Avo::Resources::IntegrationsGoogleInstallation < Avo::BaseResource
  self.includes = []
  self.model_class = ::Integrations::GoogleInstallation
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :oauth_google_account, as: :belongs_to
    field :name, as: :text
  end
end
