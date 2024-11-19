class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |t|
      t.references :team, null: false, foreign_key: true
      t.date :birth_date
      t.string :nationality
      t.string :position
      t.integer :height
      t.integer :weight
      t.jsonb :skills
      t.text :description

      t.timestamps
    end
  end
end
