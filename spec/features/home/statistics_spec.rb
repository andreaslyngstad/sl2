require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  

feature 'home' do
    get_the_gritty   
    scenario "Statistics select", js: true do  
      sign_in_on_js
      visit "http://#{@firm.subdomain}.lvh.me:31234/charts"
      find('#from_stat').click
      click_link('1')
      find('#to_stat').click
      click_link('25')
      page.should have_content(@user.name)
      find('#stats_chosen').trigger("mousedown")
      page.execute_script %Q{ $("li:contains('Stats for projects')").trigger("mouseup")}
      page.should have_content(@project.name)
    end

    scenario 'Reports', js: true do 
      sign_in_on_js
      visit "http://#{@firm.subdomain}.lvh.me:31234/reports"
      page.should have_content("Generate report")
      find('#user_id_chosen').trigger("mousedown")
      page.execute_script %Q{ $("li:contains('#{@user.name}')").trigger("mouseup")}
      find('.submit').click
      page.should have_content("2:00 name")
    end

    scenario 'timesheets', js: true do 
      sign_in_on_js
      visit "http://#{@firm.subdomain}.lvh.me:31234/timesheet_week/#{@user.id}"
      page.should have_content("Timesheet for #{@user.name}")
      page.should have_content("2:00")
      find('#timeheet_project_select_chosen').trigger("mousedown")
      page.execute_script %Q{ $("li:contains('test_project')").trigger("mouseup")}
      
      find(".log_date_#{(Date.today.beginning_of_week + 3.days).strftime('%Y-%m-%d')}").set("10")
      page.should have_content("14:00")
      # page.should have_content("10:00")
      find(".project_date_#{@project.id}_#{(Date.today.beginning_of_week + 3.days).strftime('%Y-%m-%d')}").should have_content("10:00")
      click_link('Month')
      page.should_not have_content("14:00")
      page.should have_content("10:00")
      find(".calendar_span", :text => '10:00').click
      page.should have_content("Added on timesheet")
      click_link('Week')
      find(".project_date_#{@project.id}_#{(Date.today.beginning_of_week + 3.days).strftime('%Y-%m-%d')}").should have_content("10:00")
    end
    
    scenario 'Account' do 
      sign_in_on_js
      visit "http://#{@firm.subdomain}.lvh.me:31234/firm_show"
      page.should have_content("Memeber since") 
      click_link('Subscription')
      page.should have_content("Factories_test") 
      click_link('Account')
      click_link('Payments')
      page.should have_content("Payment history") 
      click_link('Account')
      click_link('Edit preferences')
      page.should have_content("Preferences") 
      fill_in 'firm_name', with: "test_edit_firm"
      find('.submit').click
      page.should have_content("test_edit_firm") 
    end
end