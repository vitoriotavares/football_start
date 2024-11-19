class Integrations::GoogleInstallation < ApplicationRecord
  belongs_to :team
  belongs_to :oauth_google_account
end
