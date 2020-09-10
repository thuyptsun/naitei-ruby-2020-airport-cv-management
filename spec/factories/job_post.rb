FactoryBot.define do
  factory :job_post do
    title {Faker::Job.title}
    location {Faker::Address.full_address}
    salary_from {Faker::Number.number(digits: 3)}
    salary_to {Faker::Number.number(digits: 4)}
    note {Faker::Lorem.paragraph}
    description {Faker::Lorem.paragraph}
    requirement {Faker::Lorem.paragraph}
    category_id {FactoryBot.create(:category).id}
    user_id {FactoryBot.create(:user).id}
    unit_id {FactoryBot.create(:unit).id}
  end
end
