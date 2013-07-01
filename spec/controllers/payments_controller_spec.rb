require 'spec_helper'

describe PaymentsController do
	login_user 
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
  end
	let(:firm)          { @user.firm}
 	let(:subscription)  { FactoryGirl.create(:subscription, firm_id: firm.id, paymill_id: "test")}
  let(:plan)          { FactoryGirl.create(:plan, name: 'Free')}
	
	it 'renders index' do
		get :index
		response.should render_template ("index")
	end
	it "assings the right payments to @payments" do
		get :index
		payment1 = FactoryGirl.create(:payment, firm: firm)
		payment2 = FactoryGirl.create(:payment, firm: firm)
    assigns[:payments].should == [payment1,payment2]
	end

	it 'renders show and assigns payment to@payment' do
		payment1 = FactoryGirl.create(:payment, firm: firm)
		get :show, id: payment1.id
		response.should render_template ("show")
		assigns[:payment].should == payment1
	end
end
