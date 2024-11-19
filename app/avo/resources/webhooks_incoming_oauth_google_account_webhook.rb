class Avo::Resources::WebhooksIncomingOauthGoogleAccountWebhook < Avo::BaseResource
  self.includes = []
  self.model_class = ::Webhooks::Incoming::Oauth::GoogleAccountWebhook
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :data, as: :text
    field :processed_at, as: :date_time
    field :verified_at, as: :date_time
    field :oauth_google_account, as: :belongs_to
  end
end
