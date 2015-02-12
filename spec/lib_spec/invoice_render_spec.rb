require "spec_helper"
require "./lib/invoice_render.rb"
describe InvoiceRender do
	
	let(:firm)        {FactoryGirl.create(:firm, bank_account: 12, vat_number: 123)}
  let(:firm1)       {FactoryGirl.create(:firm)}
  let(:time_now)    {Time.zone.now}
  let(:user)        {FactoryGirl.create(:user, :firm => firm)}
  let(:invoice)     {FactoryGirl.create(:invoice, status: 2, customer:customer, firm:firm, due: Date.current, total: 200, receivable: 200)}
  let(:log2)        {FactoryGirl.create(:log, invoice: invoice, rate: 100, tax: 25, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 1.hours ) }
  let(:log4)        {FactoryGirl.create(:log, invoice: invoice, rate: 50, tax: 25, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 2.hours) }
  let(:log3)        {FactoryGirl.create(:log, invoice: invoice, rate: 100, tax: 10, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 1.hours ) }
  let(:invoice_line) { FactoryGirl.create(:invoice_line, invoice: invoice, quantity: 2, price: 15, tax: 25) }  
  let(:invoice_line2) { FactoryGirl.create(:invoice_line, invoice: invoice, quantity: 2, price: 6, tax: 10) }
  let(:customer) {FactoryGirl.create(:customer, firm:firm)}
	it 'creates a hash with values' do
		log2
		log3
		log4
		invoice_line
		invoice_line2
	  InvoiceRender.make_hash(invoice.id).should == {10.0=>112.0, 25.0=>230.0}
	end
  
end  