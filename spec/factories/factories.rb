
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
   time_format 1 
   date_format 1
   clock_format 1
  end
  factory :firm_no_plan, class: Firm do
   name
   subdomain
   closed false
   time_format 1 
   date_format 1
   clock_format 1
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

  factory :usernn, class: User do
    
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
  
  factory :payment do
    firm
    amount 99
    plan_name 'costly_factory'
    card_type 'rich_dude'
    last_four '1111'
  end
  factory :log do
    event "customer man"
    begin_time "2012-10-24 16:08:07 +0200"
    end_time "2012-10-24 16:09:07 +0200"
    log_date '2012-10-24'
    firm
    user
  end  

  factory :milestone do
    goal "This is the goal"
    due Date.today
    firm
  end  

  factory :todo do
    name "Todo today"
    due Date.today.strftime("%d.%m.%y")
    user
    firm
    project
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