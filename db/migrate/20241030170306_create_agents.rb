class CreateAgents < ActiveRecord::Migration[7.2]
  def change
    create_table :agents do |t|
      t.references :team, null: false, foreign_key: true
      t.string :license_number

      t.timestamps
    end
  end
end
