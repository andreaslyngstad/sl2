require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe FirmsController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
   
  end
 
  
  describe 'PUT update' do
  before :each do
    @firm = @user.firm
  end
  
  context "valid attributes" do
    it "located the requested @firm" do
      put :firm_update, id: @firm, firm: FactoryGirl.attributes_for(:firm)
      assigns(:firm).should eq(@firm)      
    end
  
    it "changes @firm's attributes" do
      put :firm_update, id: @firm, firm: FactoryGirl.attributes_for(:firm, :name => "something else")
      @firm.reload
      @firm.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    xit "locates the requested @firm" do
      put :firm_update, id: @firm, firm: FactoryGirl.attributes_for(:firm, :name => nil)
      assigns(:firm).should eq(@firm)      
    end
    
    it "does not change @firm's attributes" do
      put :firm_update, id: @firm, 
        firm: FactoryGirl.attributes_for(:firm, :name => nil)
      @firm.reload
      @firm.name.should_not eq("something else")
    end
  end
  
end
  
end