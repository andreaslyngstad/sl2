require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures
feature 'customer' do
    get_the_gritty
    
   def visit_the_customer
   
   sign_in_on_js
    visit @customers
    find("#dialog_customer").click
    fill_in "customer_name", with: "test_new customer"
    fill_in "customer_phone", with: "123456789"
    click_button "Save"
    page.should have_content("test_new customer")
    click_link("test_new customer")
    page.should have_content("123456789")
   end
     
  scenario "cycle trough links customer", js: true do
    visit_the_customer
    page.should have_content("test_new customer")
    click_link('Tasks')
    page.should have_content("New task", visible: true)
    within(:css, ('#html_tabs')) do
      click_link('Logs')
    end
    page.should have_content("New log", visible: true)
    within(:css, ('#html_tabs')) do
      click_link('Projects')
    end
    page.should have_content("New project", visible: true)
    click_link('Employees')
    page.should have_content("New employee", visible: true)
  end 

  scenario 'customer task crud' , js: true do
    visit_the_customer  
    click_link('Tasks')
    find("#dialog_todo").click
    page.should have_content("Create new task")
    fill_in "todo_name", with: "This a task"
    page.find("#new_todo").find(".submit").click
    page.should have_content("Project must be selected") 
    find('#todoProjectId_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}
    find('#dialog_todo_date').click
    click_link('13')
    # date_str = Date.today.strptime('%m.%y')
    # fill_in 'dialog_todo_date', with: "30.02.2064"
    # page.execute_script %Q{ $("#dialog_todo_date").val("20.02.2064")}
    page.find("#new_todo").find(".submit").click

    # find('.task_info')['id'].should == 'todo_1'
    id = find('.task_info')['id'].gsub('todo_', '')
    page.should have_content("This a task")  
    page.should have_content("13." + Date.today.strftime('%m.%y'))  
    page.should have_content("Task was successfully created.")
    page.find("div#not_done_tasks").first('div')[:id].should eql('todo_' + id )
    within(:css, "#todo_" + id) do 
      find(".done_box").click
    end
    
    page.should have_content("Task was successfully updated.")
    page.find("div#done_tasks").should have_content('This a task')
    
    within(:css, "#todo_" + id) do 
      find(".done_box").click
    end
  
    page.should have_content("Task was successfully updated.")
    page.find("div#not_done_tasks").should have_content('This a task')
    within(:css, "#todo_" + id) do 
      find("#todo_update").click
    end
  
    page.should have_content("Update task")
    find('#date_todo_' + id).click
    click_link('14')
    find('#edit_todo_' + id).find('.submit').click
    page.should have_content("14." + Date.today.strftime('%m.%y')) 
    find("#todo_" + id).find(".delete_todo").click
    page.should have_content("Task was successfully deleted.")
    page.should_not have_content("This a task")
  end
  scenario 'customer log crud', js: true do
    visit_the_customer
    within(:css, ('#html_tabs')) do
      click_link('Logs')
    end
    find("#dialog_log").click
    page.should have_content("Create new log")
    fill_in "log_event", with: "This a log"
    find('#logProjectId_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}
    # sleep 5
    # find('#logTodoId_chosen').trigger("mousedown")
    # page.should have_content("test_task")
    # page.execute_script %Q{ $("li:contains('test_task')").trigger("mouseup")}

    find('#log_date_new').click
    click_link('13')
    fill_in "log_times_from_", with: "10:00"
    fill_in "log_times_to_", with: "11:30"
    find('#new_log').find('.submit').click
    page.should have_content("This a log")
    page.should have_content("test_project")
    # page.should have_content("test_task")
    page.should have_content("13." + Date.today.strftime('%m.%y'))
    page.should have_content("1:30")
    
    find('.open_log_update').click
    
   
    page.should have_content('Update log')
    fill_in "log_event", with: "This a log edit"
    find('#log_edit_submit').click
    page.should have_content("This a log edit")
    
    find('.delete_log').click
    
    page.should have_content("Log was deleted")
    page.should_not have_content("This a log edit")
  end

  scenario 'customer project crud', js: true do
    visit_the_customer
    within(:css, ('#html_tabs')) do
      click_link('Projects')
    end
    find("#dialog_project").click
    page.should have_content("Create new project")
    fill_in "project_name", with: "This a project"
    fill_in "project_description", with: "This a project description"
    fill_in "project_budget", with: "3000"
    
    find('#new_project').find('.submit').click
    page.should have_content("This a project")
    page.should have_content("This a project ...")
    id = Project.where(name: 'This a project').first.id.to_s
    
    within(:css, '#project_info_' + id) do 
      find('.open_project_update').click
    end
   
    page.should have_content('Update project')
    within(:css, '#edit_project_' + id) do 
      fill_in "project_name", with: "This a edit"
      find('.submit').click
    end
    page.should have_content("This a edit")
    within(:css, '#project_info_' + id) do  
      find('.activate_projects_no_button').click
    end
    page.should have_content("Project is made inactive") 
end
  scenario 'customer employee crud', js: true do
    visit_the_customer
    within(:css, ('#html_tabs')) do
      click_link('Employee')
    end
    find("#dialog_employees").click
    page.should have_content("Create new employee")
    
    fill_in "employee_name", with: "test_new employee"
    fill_in "employee_phone", with: "123456789"
    fill_in "employee_email", with: "employee@employee.no"
    find('#new_employee').find('.submit').click
    page.should have_content("test_new employee")
    page.should have_content("123456789")
    page.should have_content("employee@employ...")

    id = Employee.where(name: 'test_new employee').first.id.to_s
    
    within(:css, '#employee_info_' + id) do 
      find('.open_employee_update').click
    end
   
    page.should have_content('Update employee')
    within(:css, '#edit_employee_' + id) do 
      fill_in "employee_name", with: "This a edit"
      find('.submit').click
    end
    page.should have_content("This a edit")
    within(:css, '#employee_info_' + id) do 
      find('.delete_employee').click
    end
  
     page.should have_content("Employee was deleted") 
  end
end

