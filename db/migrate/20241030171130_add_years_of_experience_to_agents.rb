class AddYearsOfExperienceToAgents < ActiveRecord::Migration[7.2]
  def change
    add_column :agents, :years_of_experience, :integer
  end
end
