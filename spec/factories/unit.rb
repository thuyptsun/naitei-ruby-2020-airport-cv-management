FactoryBot.define do
  factory :unit do
    name {Faker::Company.name}
    address {Faker::Address.full_address}
    email {Faker::Internet.email}
    phone_number {Faker::PhoneNumber.cell_phone_in_e164}
    overview {Faker::Lorem.paragraph}
  end
end
