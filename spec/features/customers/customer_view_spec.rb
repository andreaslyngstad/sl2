require 'spec_helper'

feature 'customer' do

    let(:user)        {FactoryGirl.create(:user)}
    let(:firm)        {user.firm} 
    let(:customers)   {"http://#{firm.subdomain}.lvh.me:31234/customers"} 
    let(:root_url)    {"http://#{firm.subdomain}.lvh.me:31234/"}
    before(:all) do 
      
      Capybara.server_port = 31234 
      sub = firm.subdomain
      Capybara.app_host = root_url 
    end
   def sign_in_on_js
    visit root_url
    fill_in "Email", :with => user.email
    fill_in "Password", :with => "password"
    click_button "Sign in"
    page.should have_content("Signed in successfully.") 
   end
   def visit_the_customer
    sign_in_on_js
    visit customers
    find("#dialog_customer").click
    fill_in "customer_name", with: "test_new customer"
    fill_in "customer_phone", with: "123456789"
    click_button "Save"
    page.should have_content("test_new customer")
    id = page.evaluate_script("$('.open_customer_update').first().attr('data-id');")
    li = "li#customer_#{id}"
    within(:css, li) do
      click_link("test_new customer")
    end
    
    page.should have_content("123456789")
   end
     
  scenario "view customer", js: true do
    visit_the_customer
  end 
  scenario "todo crud on customer", js: true do
    visit_the_customer
    id = Customer.find_by_name("test_new customer").id
    click_link "Tasks"
    page.current_url.should == "http://#{firm.subdomain}.lvh.me:31234/customers/#{id}#tabs-1"
    find("#dialog_todo").click
    page.should have_content("Create new task test_new customer")
    fill_in "todo_name", with: "This a task"
    page.execute_script %Q{ $('#dialog_todo_date').trigger("focus") } # activate datetime picker
    page.execute_script %Q{ $('a.ui-datepicker-next').trigger("click") } # move one month forward
    page.execute_script %Q{ $('a.ui-state-default:contains("15")').trigger("click") } # click on day 15
    page.find("#new_todo").find(".submit").click
    page.should have_content("This a task")
    page.should have_content("15")
    find(".done_box#1").click
  end
 
end