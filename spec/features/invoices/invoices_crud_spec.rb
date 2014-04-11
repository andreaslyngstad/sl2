require 'spec_helper'
require 'features/subdomain_login_features'
include SubdomainLoginFeatures  
feature 'invoice' do
    get_the_gritty   
  scenario "make new", js: true do
    sign_in_on_js   
    visit @invoices 
    page.should have_content("New invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create new invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.should have_content('test_customer')
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}
    page.find('#new_invoice').find('.submit').click
    page.should have_content("Invoice is added.")
  end 

  scenario "invoice form", js:true do
    sign_in_on_js   
    visit @invoices 
    page.should have_content("New invoice")        
    find("#dialog_invoice").click
    page.should have_content("Create new invoice")
    page.find('#invoice_customer_id_chosen').trigger("mousedown")
    page.execute_script %Q{ $("li:contains('test_customer')").trigger("mouseup")}
    page.should have_content ("test_log")
    page.should have_content ("25 4 1 5 Total 5")
    click_link("Add Line")
    within(:css, "tr.invoice_line") do
        find(:css, "input.invoice_line_description").set("test_line")
        find(:css, "input.invoice_line_quantity").set("2")
        find(:css, "input.invoice_line_price").set("2")
    end
   
    page.should have_content ("25 8 2 10 Total 10")
    page.find('#new_invoice').find('.submit').click
    page.should have_content("Invoice is added.")
    page.should have_content ("No number 10")
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