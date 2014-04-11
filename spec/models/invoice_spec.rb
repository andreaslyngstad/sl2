require "spec_helper"

describe Invoice do
  it {should belong_to(:firm)}
  it {should belong_to(:customer)}
  it {should belong_to(:project)}
  it {should have_many(:logs)} 
  it {should validate_presence_of(:customer_id) } 
  it {should accept_nested_attributes_for :invoice_lines }
  let(:firm)     {FactoryGirl.create(:firm, bank_account: 12, vat_number: 123)}
  let(:firm1)     {FactoryGirl.create(:firm)}
  let(:invoice)  {FactoryGirl.create(:invoice, customer:customer, firm:firm, due: Date.today)}
  let(:invoice1)   {FactoryGirl.create(:invoice, customer:customer, firm:firm , number: 2, due: Date.today + 1.day, paid: nil)}
  let(:invoice2)   {FactoryGirl.create(:invoice, customer:customer, firm:firm , number:3, due: Date.today - 1.day, paid: Date.today)}
  let(:customer) {FactoryGirl.create(:customer, firm:firm)}

  it "gives translated string for status" do
  	FactoryGirl.create(:invoice, customer:customer, firm:firm).status_string.should eq "Draft"
  	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 2).status_string.should eq "Sent"
  	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 5).status_string.should eq "Reminded"
  end
  it "gives number or string" do
  	invoice.number_string.should eq "No number"
  	invoice1.number_string.should eq 2
  end
  # scopes
  it 'gets the last numberd invoice for spesific firm' do 
    invoice1
    invoice2
    Invoice.last_with_number(firm).number.should eq 3
  end
  it "should return invoices ordered by number" do
    first = invoice1
    last = invoice2
    Invoice.order_by_number.should == [last, first]
  end
  it 'should be saved on correct firm' do
    firm2 = FactoryGirl.create(:firm)
    test = FactoryGirl.build(:invoice,customer:customer, :firm => firm2)
    test.should_not be_valid
    test.errors[:firm_id].should be_present
  end
  context "due and overdue" do 
    it 'due_today? returns true if due else false' do
      invoice.due_today_or_overdue
      invoice.status.should eq 3
      invoice1.due_today_or_overdue
      invoice1.status.should eq 1
      invoice2.due_today_or_overdue
      invoice2.status.should eq 4
    end
  end
  it 'should not get a number if firm bank account or vat number is empty' do
    firm.bank_account = nil
    test = FactoryGirl.build(:invoice,customer:customer, :firm => firm , number: 2)
    test.should_not be_valid
    test.errors[:Firm].should be_present
  end
  it 'should set paid to day when nil and nil when paid not nil' do
    invoice1.paid!
    invoice1.paid.should eq Date.today
    invoice2.paid!
    invoice2.paid.should eq nil
  end
end