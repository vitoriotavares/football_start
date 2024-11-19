class CreateWebhooksIncomingOauthGoogleAccountWebhooks < ActiveRecord::Migration[7.2]
  def change
    create_table :webhooks_incoming_oauth_google_account_webhooks do |t|
      t.jsonb :data
      t.datetime :processed_at
      t.datetime :verified_at
      t.references :oauth_google_account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
