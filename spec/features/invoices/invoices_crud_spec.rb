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
    fill_in "invoice_name", with: "" 
    click_button "Save"
    page.should have_content("This field is required.")
    fill_in "invoice_name", with: "test_new invoice"
    fill_in "invoice_phone", with: "123456789"
    fill_in "invoice_email", with: "test@tes.no"
    fill_in "invoice_address", with: "new invoice address" 
    click_button "Save"
    page.should have_content("test_new invoice")
  end 
  scenario "Edit invoice", js: true do
    sign_in_on_js
    visit @invoices 
    page.should have_content("test_new invoice")  
    id = page.evaluate_script("$('.open_invoice_update').first().attr('data-id');")
    li = "li#invoice_#{id}"
    within(:css, li) do
      first(".open_invoice_update").click  
    end 
    page.should have_content("Update invoice")
    fill_in "invoice_name_#{id}", with: "test_new_edit invoice"
    page.find("#edit_invoice_#{id}").find(".submit").click
    page.should have_content("test_new_edit invoice") 
  end 
  scenario "delete invoice", js: true do
    sign_in_on_js
    visit @invoices
    id = page.evaluate_script("$('.open_invoice_update').first().attr('data-id');")
    li = "li#invoice_#{id}"
    within(:css, li) do
      first(".button").click 
    end
    page.should have_content("invoice was successfully deleted.") 
  end
end