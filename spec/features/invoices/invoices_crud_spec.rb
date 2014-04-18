
require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'invoice' do
    get_the_gritty   
  scenario "make new", js: true do
    sign_in_on_js   
    visit @invoices 
    page.should have_content("Create invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.should have_content('test_customer')
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}
    page.find('#new_invoice').find('.submit').click
    page.should have_content("was successfully saved")
  end 

  scenario "invoice form", js:true do
    sign_in_on_js   
    visit @invoices 
    page.should have_content("Create invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}
    page.should have_content ("test_log")
    page.should have_content ("25 4,00 1,00 5,00 Total 5,00")
    click_link("Add Line")
    within(:css, "tr.invoice_line") do
        find(:css, "input.invoice_line_description").set("test_line")
        find(:css, "input.invoice_line_quantity").set("2")
        find(:css, "input.invoice_line_price").set("2")
    end
   
    page.should have_content ("25 8,00 2,00 10,00 Total 10,00")
    page.find('#new_invoice').find('.submit').click
    page.should have_content("was successfully saved")
    page.should have_content ("No number test_customer 10")
  end
  # scenario "Edit invoice", js: true do
  #   sign_in_on_js
  #   visit @invoices 
  #   page.should have_content("test_new invoice")  
  #   id = page.evaluate_script("$('.open_invoice_update').first().attr('data-id');")
  #   li = "li#invoice_#{id}"
  #   within(:css, li) do
  #     first(".open_invoice_update").click  
  #   end 
  #   page.should have_content("Update invoice")
  #   fill_in "invoice_name_#{id}", with: "test_new_edit invoice"
  #   page.find("#edit_invoice_#{id}").find(".submit").click
  #   page.should have_content("test_new_edit invoice") 
  # end 
  # scenario "delete invoice", js: true do
  #   sign_in_on_js
  #   visit @invoices
  #   id = page.evaluate_script("$('.open_invoice_update').first().attr('data-id');")
  #   li = "li#invoice_#{id}"
  #   within(:css, li) do
  #     first(".button").click 
  #   end
  #   page.should have_content("invoice was successfully deleted.") 
  # end
end