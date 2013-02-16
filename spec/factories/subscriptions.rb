# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    plan_id 1
    email "MyString@test.no"
    firm_id 1
    name "Yes"
    paymill_id 1
    
  end
end
