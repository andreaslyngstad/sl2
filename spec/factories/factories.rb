
FactoryGirl.define do 
  sequence(:random_string) {|n| "name#{n}" }
  sequence(:name) { |n|"name#{n}"}
  sequence(:subdomain) { |n| "subdomain#{n}"}
  sequence(:email) { |n| "foo#{n}@example.com" }
 
  factory :firm do
   name
   subdomain
  end


  factory :user do
    name
    password "foobar"
    password_confirmation { |u| u.password }
    email
    role "Admin"
    firm
  end 

  factory :project do
    name
    active true
    firm
  end  

  factory :log do
    event "customer man"
    begin_time "2012-10-24 16:08:07 +0200"
    end_time "2012-10-24 16:09:07 +0200"
    firm
    user
  end  

  factory :milestone do
    goal "This is the goal"
    firm
  end  

  factory :todo do
    name "Todo today"
    firm
  end  

  factory :employee do
    name "employee guy"
    firm
    customer
  end  

  factory :customer do
    name "customer man"
    firm
  end  
end