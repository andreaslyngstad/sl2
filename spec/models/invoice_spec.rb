require "spec_helper"
describe Invoice do
  it {should belong_to(:firm)}
  it {should belong_to(:customer)}
  it {should belong_to(:project)}
  it {should have_many(:logs)} 
  it {should have_many(:credit_notes)} 
  it {should belong_to(:invoice)} 
   
  it {should accept_nested_attributes_for :invoice_lines }
  
  let(:firm)        {FactoryGirl.create(:firm, bank_account: 12, vat_number: 123)}
  let(:firm1)       {FactoryGirl.create(:firm)}
  let(:time_now)    {Time.now}
  let(:user)        {FactoryGirl.create(:user, :firm => firm)}
  let(:invoice)     {FactoryGirl.create(:invoice, status: 2, customer:customer, firm:firm, due: Date.today, total: 200, receivable: 200)}
  let(:credit_note) {FactoryGirl.create(:invoice, status: 7,  invoice: invoice, customer:customer, firm:firm, due: Date.today, total: -199)}
  let(:reminder)    {FactoryGirl.create(:invoice, status: 10, reminder_on: invoice, customer: customer, firm:firm, due: Date.today, total: 250, reminder_fee: 50)}
  let(:log2)        {FactoryGirl.create(:log, invoice: invoice, rate: 101.001, tax: 25, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 2.hours ) }
  let(:log4)        {FactoryGirl.create(:log, invoice: invoice, rate: 11, tax: 25, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 2.hours ) }
  let(:log3)        {FactoryGirl.create(:log, invoice: invoice, rate: 100, tax: 10, :user => user, :firm => firm, :begin_time => time_now, :end_time => time_now + 4.hours ) }
  let(:invoice_line) { FactoryGirl.create(:invoice_line, invoice: invoice, quantity: 2, price: 15, tax: 25) }  
  let(:invoice_line2) { FactoryGirl.create(:invoice_line, invoice: invoice, quantity: 2, price: 6, tax: 10) }
  let(:invoice1)    {FactoryGirl.create(:invoice, status: 2, customer:customer, firm:firm , number: 2, due: Date.today + 1.day, paid: nil, receivable: 200 )}
  let(:invoice2)    {FactoryGirl.create(:invoice, status: 2, customer:customer, firm:firm , number:3, due: Date.today - 1.day, paid: Date.today, total: 200, lost: 200)}
  let(:credit_note2) {FactoryGirl.create(:invoice, status: 7,  invoice: invoice2, customer:customer, firm:firm, due: Date.today, total: -199)}
  let(:reminder2)    {FactoryGirl.create(:invoice, status: 10, reminder_on: invoice2, customer: customer, firm:firm, due: Date.today, total: 250, reminder_fee: 50)}
  let(:customer) {FactoryGirl.create(:customer, firm:firm)}

  it 'sets the receivable eq to the total on creation' do
    invoice.receivable.should eq 200
  end

  it 'validates out when credit_note total is bigger than invoice receivable' do 
    credit_note.should be_valid
  end

  it "sets status to reminded" do 
    invoice.set_status_to_reminded("50")
    invoice.reload
    invoice.status.should eq 5
    invoice.reminder_sent.should eq Date.today 
    invoice.receivable.should eq 250
  end

  it "sums cretit notes and reminders" do
    reminder
    credit_note
    invoice.sum_credit_notes_and_reminders.should eq -149
  end

  it 'creates a reminder' do 
    reminder = invoice.create_reminder({reminder_fee: 50, content: "test"})
    reminder.reminder_fee.should eq 50 
    reminder.total.should eq 250
  end

  it 'validates the presence of customer' do
    FactoryGirl.build(:invoice, status: 2,  firm:firm , number: 2, due: Date.today + 1.day, paid: nil).should_not be_valid
  end
  
  it "gives translated string for status" do
  	FactoryGirl.create(:invoice, customer:customer, firm:firm).status_string.should eq ['black', "Draft"]
  	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 2).status_string.should eq ['black', "Sent"]
  	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 5).status_string.should eq ['orange',"Reminded"]
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
    Invoice.destroy_all
    first = invoice1
    last = invoice2
    Invoice.order_by_number.should == [invoice, last, first]
  end
  it 'should be saved on correct firm' do
    firm2 = FactoryGirl.create(:firm)
    test = FactoryGirl.build(:invoice,customer:customer, :firm => firm2)
    test.should_not be_valid
    test.errors[:base].should be_present
  end
  context "due and overdue" do 
    it 'due_today? returns true if due else false' do
      invoice.due_today_or_overdue
      invoice.status.should eq 3
      invoice1.due_today_or_overdue
      invoice1.status.should eq 2
      invoice2.due_today_or_overdue
      invoice2.status.should eq 4
    end
  end
  it 'should not get a number if firm bank account or vat number is empty' do
    firm.bank_account = nil
    test = FactoryGirl.build(:invoice,customer:customer, :firm => firm , number: 2)
    test.should_not be_valid
    test.errors[:base].should be_present
  end
  it 'should set paid to day when nil and nil when paid not nil' do
    invoice1.paid!
    invoice1.paid.should eq Date.today
    invoice1.status.should eq 6
    invoice1.receivable.should eq 0
    credit_note2
    reminder2
    invoice2.paid!
    invoice2.status.should eq 7
    invoice2.receivable.should eq 51
    invoice2.paid.should eq nil
  end

  it 'should set paid to day when nil and nil when paid not nil' do
    invoice1.receivable = 100
    invoice1.receivable.should eq 100
    invoice1.lost!
    invoice1.lost.should eq 100
    invoice1.status.should eq 11
    invoice1.receivable.should eq 0
    credit_note2
    reminder2
    invoice2.lost!
    invoice2.status.should eq 7
    invoice2.receivable.should eq 51
    invoice2.lost.should eq nil
  end

  it 'should return the tax lines for the invoice' do
    h = {25.0=>317.5, 10.0=>453.2}
    log2
    log3
    log4
    invoice_line
    invoice_line2
    invoice.tax_lines.should eq h
  end
  it 'should return subtotal' do
    h = {25.0=>317.5, 10.0=>453.2}
    log2
    log3
    log4
    invoice_line
    invoice_line2
    invoice.subtotal.should eq 666.0
  end
end