require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'project' do
    get_the_gritty   
  scenario "make new", js: true do
    sign_in_on_js   
    visit @projects 
    page.should have_content("New project")       
    find("#dialog_project").click
    page.should have_content("Create new project")
    fill_in "project_name", with: "" 
    click_button "Save"
    page.should have_content("This field is required.")
    fill_in "project_name", with: "test_new project"
    fill_in "project_description", with: "123456789"
    fill_in "project_budget", with: "test@tes.no"
    # fill_in "project_address", with: "new project address" 
    click_button "Save"
    page.should have_content("test_new project")
  end 
  scenario "Edit project", js: true do
    sign_in_on_js
    visit @projects 
    page.should have_content("test_new project")  
    id = page.evaluate_script("$('.open_project_update').first().attr('data-id');")
    li = "li#project_#{id}"
    within(:css, li) do
      first(".open_project_update").click  
    end 
    page.should have_content("Update project")
    fill_in "project_name", with: "test_new_edit project"
    page.find("#edit_project_#{id}").find(".submit").click
    page.should have_content("test_new_edit project") 
  end 
  scenario "archive project", js: true do
    sign_in_on_js
    visit @projects
    id = page.evaluate_script("$('.open_project_update').first().attr('data-id');")
    li = "li#project_#{id}"
    within(:css, li) do
      find("#archive_#{id}").click 
    end
    page.should have_content("Project is made inactive") 
  end
  scenario "reopen and delete project", js: true do
    sign_in_on_js
    visit @projects
    find("#archive").click
    page.should have_content("test_new_edit project")
    id = page.evaluate_script("$('.reopen_project').first();")
    first('.reopen_project').click
    page.should have_content("Project is made active")
    find("#active_projects").click 
    page.should have_content("test_new_edit project")
    first('.activate_project').click
    page.should have_content("Project is made inactive")
    find("#archive").click
    first('.delete_project').trigger('click')
	page.should have_content("Project was deleted")
  end
end
