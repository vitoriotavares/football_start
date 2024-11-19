class Avo::Resources::Agency < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :team, as: :belongs_to
    field :name, as: :text
    field :location, as: :text
    field :position, as: :text
    field :contact_info, as: :text
    field :license_number, as: :text
  end
end
