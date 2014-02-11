require "spec_helper"

describe Invoice do
   it {should belong_to(:firm)}
   it {should belong_to(:customer)}
   it {should belong_to(:project)}
   it {should have_many(:logs)} 
   it {should validate_presence_of(:customer_id) } 
   it {should accept_nested_attributes_for :invoice_lines }
   let(:firm)     {FactoryGirl.create(:firm)}
  
   let(:customer) {FactoryGirl.create(:customer, firm:firm)}

   it "gives translated string for status" do
   	FactoryGirl.create(:invoice, customer:customer, firm:firm).status_string.should eq "Draft"
   	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 2).status_string.should eq "Sent"
   	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 3).status_string.should eq "Due"
   	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 4).status_string.should eq "Overdue"
   	FactoryGirl.create(:invoice, customer:customer, firm:firm, status: 5).status_string.should eq "Reminded"
   end
   it "gives number or string" do
   	FactoryGirl.create(:invoice, customer:customer, firm:firm).number_string.should eq "No number"
   	FactoryGirl.create(:invoice, customer:customer, firm:firm, number: 2).number_string.should eq 2
   end
   it 'should be saved on correct firm' do
    firm2 = FactoryGirl.create(:firm)
    test = FactoryGirl.build(:invoice,customer:customer, :firm => firm2)
    test.should_not be_valid
    test.errors[:firm_id].should be_present
  end
end