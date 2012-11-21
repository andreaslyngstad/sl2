require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe CustomersController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
   
  end
  describe "activate_customers and deactivate_customers" do
    it "deactivate_customers" do 
      @customer = FactoryGirl.create(:customer)
      expect{
          get :activate_customers, :id => @customer.id
        }.to change(Customer.where(:active => true),:count).by(-1)
    end
    it "activate_customers" do 
      @customer = FactoryGirl.create(:customer, :active => false)
      expect{
          get :activate_customers, :id => @customer.id
        }.to change(Customer.where(:active => true),:count).by(1)
    end
  end
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of customers" do
      @customer = FactoryGirl.create(:customer)
      get :index
      assigns(:customers) == [@customer]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  
  describe "GET #show" do
    it "assigns the requested customer to @customer" do
      @customer = FactoryGirl.create(:customer, :firm => @user.firm)
      get :show, :id => @customer
      assigns(:customer) == [@customer] 
    end
    it "renders the #show view" do
      @customer = FactoryGirl.create(:customer, :firm => @user.firm)
      get :show, :id => @customer
      response.should render_template :show
    end
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, customer: FactoryGirl.attributes_for(:customer)
        }.to change(Customer,:count).by(1)
      end
      
      it "redirects to the new contact" do
        post :create, customer: FactoryGirl.attributes_for(:customer)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @customer = FactoryGirl.create(:customer, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @customer, customer: FactoryGirl.attributes_for(:customer)
      assigns(:customer).should eq(@customer)      
    end
  
    it "changes @customer's attributes" do
      put :update, id: @customer, customer: FactoryGirl.attributes_for(:customer, :name => "something else")
      @customer.reload
      @customer.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @customer" do
      put :update, id: @customer, customer: FactoryGirl.attributes_for(:customer, :name => nil)
      assigns(:customer).should eq(@customer)      
    end
    
    it "does not change @customer's attributes" do
      put :update, id: @customer, 
        customer: FactoryGirl.attributes_for(:customer, :name => nil)
      @customer.reload
      @customer.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @customer = FactoryGirl.create(:customer, :firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @customer        
      }.to change(Customer,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @customer
      flash[:notice].should_not be_nil
    end
  end
end