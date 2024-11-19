FactoryBot.define do
  factory :agent do
    association :team
    license_number { "MyString" }
  end
end
