
FactoryGirl.define do 
  sequence(:random_string) {|n| "name#{n}" }
  sequence(:name) { |n|"name#{n}"}
  sequence(:subdomain) { |n| "subdomain#{n}"}
  sequence(:email) { |n| "foo#{n}@example.com" }
end
FactoryGirl.define do 
  factory :firm do
    name
    subdomain 
  end
end
FactoryGirl.define do 
  factory :user do
    name
    password "foobar"
    password_confirmation { |u| u.password }
    email
    firm
  end  
end
