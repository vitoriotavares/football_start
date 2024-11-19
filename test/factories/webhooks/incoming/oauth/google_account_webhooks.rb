FactoryBot.define do
  factory :webhooks_incoming_oauth_google_account_webhook, class: 'Webhooks::Incoming::Oauth::GoogleAccountWebhook' do
    data { "" }
    processed_at { "2024-10-31 14:54:10" }
    verified_at { "2024-10-31 14:54:10" }
    oauth_google_account { nil }
  end
end
