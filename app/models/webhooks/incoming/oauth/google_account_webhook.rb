class Webhooks::Incoming::Oauth::GoogleAccountWebhook < ApplicationRecord
  belongs_to :oauth_google_account
end
