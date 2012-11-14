require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe TodosController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"   
    @project = FactoryGirl.create(:project, :firm => @user.firm)
  end
  
  
  describe "POST create" do
    before(:each) do
      
    end
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, todo: FactoryGirl.attributes_for(:todo, :firm_id => @user.firm.id, :project_id => @project.id)
        }.to change(Todo,:count).by(1)
      end
      
      it "Should show flash" do
        post :create, todo: FactoryGirl.attributes_for(:todo, :firm_id => @user.firm.id, :project_id => @project.id)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @todo = FactoryGirl.create(:todo, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @todo, todo: FactoryGirl.attributes_for(:todo)
      assigns(:todo).should eq(@todo)      
    end
  
    it "changes @todo's attributes" do
      put :update, id: @todo, todo: FactoryGirl.attributes_for(:todo, :name => "something else")
      @todo.reload
      @todo.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @todo" do
      put :update, id: @todo, todo: FactoryGirl.attributes_for(:todo, :name => nil)
      assigns(:todo).should eq(@todo)      
    end
    
    it "does not change @todo's attributes" do
      put :update, id: @todo, 
        todo: FactoryGirl.attributes_for(:todo, :name => nil)
      @todo.reload
      @todo.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @todo = FactoryGirl.create(:todo, :firm_id => @user.firm.id, :project_id => @project.id)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @todo        
      }.to change(Todo,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @todo
      flash[:notice].should_not be_nil
    end
  end
end