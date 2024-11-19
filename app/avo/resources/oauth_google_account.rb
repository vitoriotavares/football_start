class Avo::Resources::OauthGoogleAccount < Avo::BaseResource
  self.includes = []
  self.model_class = ::Oauth::GoogleAccount
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :uid, as: :text
    field :data, as: :text
    field :user, as: :belongs_to
  end
end
