class CreateOauthGoogleAccounts < ActiveRecord::Migration[7.2]
  def change
    create_table :oauth_google_accounts do |t|
      t.string :uid
      t.jsonb :data
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
