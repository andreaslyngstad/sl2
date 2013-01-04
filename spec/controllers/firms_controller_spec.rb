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
 
  context "invalid attributes" do
    it "does not update @firm's invalid attributes" do
      put :firm_update, id: @firm, 
        firm: FactoryGirl.attributes_for(:firm, :name => nil)
      @firm.reload
      @firm.name.should_not eq("something else")
    end
  end  
end
end