class Avo::Resources::Player < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :birth_date, as: :date
    field :nationality, as: :text
    field :position, as: :text
    field :height, as: :number
    field :weight, as: :number
    field :skills, as: :text
    field :description, as: :textarea
  end
end
