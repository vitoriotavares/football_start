FactoryBot.define do
  factory :player do
    association :team
    birth_date { "2024-10-30" }
    nationality { "MyString" }
    position { "MyString" }
    height { 1 }
    weight { 1 }
    skills { "" }
    description { "MyText" }
  end
end
