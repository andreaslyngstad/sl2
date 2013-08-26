require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe FirmsController do 
  login_user
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
   
  end
 describe "GET #firm_show" do
   it "assigns the requested project to @project" do
     get :firm_show, :id => @user.firm
     assigns(:firm) == [@user.firm] 
   end
   it "renders the #show view" do
     get :firm_show, :id => @user.firm
     response.should render_template :firm_show
   end
   it "renders access_denied when user is External user" do
      @user.role = "External user"
      @user.save
      get :firm_edit, :id => @user.firm
      expect(response).to render_template("access_denied")
    end
 end
  describe "GET #firm_edit" do
   it "assigns the requested project to @project" do
     get :firm_edit, :id => @user.firm
     assigns(:firm) == [@user.firm] 
   end
   it "renders the #firm_edit view" do
     get :firm_edit, :id => @user.firm
     response.should render_template :firm_edit
   end
   it "renders access_denied when user is member" do
      @user.role = "Member"
      @user.save
      get :firm_edit, :id => @user.firm
      expect(response).to render_template("access_denied")
    end
  end
  
  describe 'PUT update' do
  before :each do 
    @firm = @user.firm
  end
 context "valid attributes" do
    it "located the requested @user" do
      put :firm_update, id: @firm, firm: FactoryGirl.attributes_for(:firm)
      assigns(:firm).should eq(@firm)      
    end
  
    it "changes @user's attributes" do
      put :firm_update, id: @firm, firm: FactoryGirl.attributes_for(:firm, :name => "something else")
      @firm.reload
      @firm.name.should eq("something else")
      flash[:notice].should == "Account was successfully updated."
    end
  end
  context "invalid attributes" do
    it "does not update @firm's invalid attributes" do
      put :firm_update, id: @firm,firm: FactoryGirl.attributes_for(:firm, :name => nil)
      @firm.reload
      @firm.name.should_not eq("something else")
    end
  end  
end
  describe 'DELETE destroy' do
    
      let(:firm){ @user.firm}
       
    it "deletes the firm" do
      expect{
        delete :destroy, id: firm        
      }.to change(Firm,:count).by(-1)
    end
    it "redirects to firm#index" do
      delete :destroy, id: firm
      response.should redirect_to root_url(:subdomain => nil)
    end
    it "renders access_denied when user is member" do
      @user.role = "Member"
      @user.save
      get :destroy, :id => firm
      expect(response).to render_template("access_denied")
    end
    it "renders access_denied when user is External user" do
      @user.role = "External user"
      @user.save
      get :destroy, :id => @user.firm
      expect(response).to render_template("access_denied")
    end
  end 
end