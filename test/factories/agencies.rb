FactoryBot.define do
  factory :agency do
    association :team
    name { "MyString" }
    location { "MyString" }
    position { "MyString" }
    contact_info { "MyString" }
    license_number { "MyString" }
  end
end
