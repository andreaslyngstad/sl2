# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    id 1
    paymill_id "offer_b72bdb7a4539757ee843"
    name "test"
    price 99
    initialize_with {Plan.find_or_create_by_id(id)}
  end
end
