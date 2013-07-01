require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures
feature 'customer' do
    get_the_gritty
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
  # scenario "todo crud on customer", js: true do
  #   visit_the_customer
  #   id = Customer.find_by_name("test_new customer").id
  #   click_link "Tasks"
  #   page.current_url.should == "http://#{firm.subdomain}.lvh.me:31234/customers/#{id}#tabs-1"
  #   find("#dialog_todo").click
  #   page.should have_content("Create new task")
  #   fill_in "todo_name", with: "This a task"
  #   page.find("#new_todo").find(".submit").click
  #   page.should have_content("Project must be selected")   
  #   page.execute_script %Q{ $(".chzn-results").find("li:contains('test_project')").parent().trigger("mousedown")}
  #   page.execute_script %Q{ $(".chzn-results").find("li:contains('test_project')").trigger("mouseup")}
  #   page.execute_script %Q{ $("#dialog_todo_date").val("20.02.2064")}
  #   # fill_in "#dialog_todo_date", with: "04.06.13"
  #   page.find("#new_todo").find(".submit").click
  #   page.should have_content("This a task")  
  #   page.should have_content("Task was successfully created.")
  #   id = page.find("div#not_done_tasks").first('div', text: "This a task")[:id]
  #   find("#" + id).find(".done_box").click
  #   page.should have_content("Task was successfully updated.")
  #   page.find("div#done_tasks").first('div', text: "This a task")[:id].should eql(id)
  #   find("#" + id).find(".done_box").click
  #   find("#" + id).find(".edit").click
  # end
end

# $(".chzn-results").find("li:contains('test2')").parent().trigger("mousedown")
# $(".chzn-results").find("li:contains('test2')").trigger("mouseup")
# $("#dialog_todo_date").val("20.02.2064")