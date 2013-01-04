require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe EmployeesController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
    @customer = FactoryGirl.create(:customer, :firm => @user.firm)
  end
  
  
  describe "POST create" do
   
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, employee: FactoryGirl.attributes_for(:employee, :customer_id => @customer.id)
        }.to change(Employee,:count).by(1)
      end
      
      it "Should show flash" do
        post :create, employee: FactoryGirl.attributes_for(:employee, :customer_id => @customer.id)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @employee = FactoryGirl.create(:employee, :customer_id => @customer.id, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @employee" do
      put :update, id: @employee, employee: FactoryGirl.attributes_for(:employee)
      assigns(:employee).should eq(@employee)      
    end

    it "changes @employee's attributes" do
      put :update, id: @employee, employee: FactoryGirl.attributes_for(:employee, :name => "something else")
      @employee.reload
      @employee.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @employee" do
      put :update, id: @employee, employee: FactoryGirl.attributes_for(:employee, :name => nil)
      assigns(:employee).should eq(@employee)      
    end
    
    it "does not change @employee's attributes" do
      put :update, id: @employee, 
        employee: FactoryGirl.attributes_for(:employee, :name => nil)
      @employee.reload
      @employee.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @employee = FactoryGirl.create(:employee, :customer_id => @customer.id, :firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @employee        
      }.to change(Employee,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @employee
      flash[:notice].should_not be_nil
    end
  end
end