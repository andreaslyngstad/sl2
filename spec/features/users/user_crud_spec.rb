require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'user' do
    get_the_gritty   
  scenario "make new", js: true do
    sign_in_on_js   
    visit @users 
    page.should have_content("New user")       
    find("#dialog_user").click
    page.should have_content("Create new user")
    fill_in "user_name", with: "" 
    click_button "Save"
    page.should have_content("This field is required.")
    fill_in "user_name", with: "test_new user"
    fill_in "user_phone", with: "123456789"
    fill_in "user_email", with: "test@tes.no"
    fill_in "user_password", with: "password" 
    page.find('#new_user').find('.submit').click
    page.should have_content("Registration successful")
    page.should have_content("test_new user")
  end 
  scenario "Edit user", js: true do
    sign_in_on_js
    visit @users 
    page.should have_content("test_new user")  
    id = page.evaluate_script("$('.open_user_update').first().attr('data-id');")
    li = "li#user_#{id}"
    within(:css, li) do
      first(".open_user_update").click  
    end 
    page.should have_content("Update user")
    fill_in "user_name", with: "test_new_edit user"
    page.find("#edit_user_#{id}").find(".submit").click
    page.should have_content("test_new_edit user") 
    page.should have_content("Successfully updated profile") 
  end 
  scenario "delete yourself", js: true do
    sign_in_on_js
    visit @users
    id = page.evaluate_script("$('.open_user_update').first().attr('data-id');")
    li = "li#user_#{id}"
    within(:css, li) do
      first(".delete_user").trigger('click')
    end
    page.should have_content("You cannot delete yourself") 
  end
  scenario "delete user", js: true do
    sign_in_on_js
    visit @users
    id = page.evaluate_script("$('.open_user_update').last().attr('data-id');")
    li = "li#user_#{id}"
    within(:css, li) do
      first(".delete_user").trigger('click')
    end
    page.should have_content("test_new user was deleted") 
  end
end