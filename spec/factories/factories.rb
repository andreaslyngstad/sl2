
FactoryGirl.define do 
  sequence(:random_string) {|n| "name#{n}" }
  sequence(:name) { |n|"name#{n}"}
  sequence(:subdomain) { |n| "subdomain#{n}"}
  sequence(:email) { |n| "foo#{n}@example.com" }
 
  factory :firm do
   name
   subdomain
   plan
   closed false
  end
  factory :firm_with_users, :parent => :firm do
    after_create do |firm|
      FactoryGirl.create(:user, :firm => firm)
    end
  end
  factory :user do
    name
    password "password"
    password_confirmation { |u| u.password }
    email
    role "Admin"
    firm
  end 

  factory :project do
    name
    active true
    firm
    due Date.today
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
    due Date.today.strftime("%d.%m.%y")
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
  factory :guide do
    title "test"
    content "test"  
  end
  factory :blog do
    author "test"
    title "test"
    content "test"  
  end
end