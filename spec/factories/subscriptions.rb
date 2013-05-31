# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    active true
    paymill_id "test"
    email
    name 
    firm
    plan
    
    
  end 
end
