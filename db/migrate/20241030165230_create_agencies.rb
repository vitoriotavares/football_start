class CreateAgencies < ActiveRecord::Migration[7.2]
  def change
    create_table :agencies do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name
      t.string :location
      t.string :position
      t.string :contact_info
      t.string :license_number

      t.timestamps
    end
  end
end
