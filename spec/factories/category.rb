FactoryBot.define do
  factory :category do
    title {Faker::Job.field}
  end
end
