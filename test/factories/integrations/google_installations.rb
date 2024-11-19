FactoryBot.define do
  factory :integrations_google_installation, class: 'Integrations::GoogleInstallation' do
    team { nil }
    oauth_google_account { nil }
    name { "MyString" }
  end
end
