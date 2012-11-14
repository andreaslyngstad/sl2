require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe ProjectsController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
   
  end
  describe "activate_projects and deactivate_projects" do
    it "deactivate_projects" do 
      @project = FactoryGirl.create(:project)
      expect{
          get :activate_projects, :id => @project.id
        }.to change(Project.where(:active => true),:count).by(-1)
    end
    it "activate_projects" do 
      @project = FactoryGirl.create(:project, :active => false)
      expect{
          get :activate_projects, :id => @project.id
        }.to change(Project.where(:active => true),:count).by(1)
    end
  end
  describe "GET #index" do
    it "should have a current_user" do
      subject.current_user.should_not be_nil
      subject.current_firm.should_not be_nil
    end
    it "populates an array of projects" do
      @project = FactoryGirl.create(:project)
      get :index
      assigns(:projects) == [@project]   
    end
    it "renders the :index view" do
      get :index
      response.should render_template("index")
    end
  end 
  
  describe "GET #show" do
    it "assigns the requested project to @project" do
      @project = FactoryGirl.create(:project, :firm => @user.firm)
      get :show, :id => @project
      assigns(:project) == [@project] 
    end
    it "renders the #show view" do
      @project = FactoryGirl.create(:project, :firm => @user.firm)
      get :show, :id => @project
      response.should render_template :show
    end
  end
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, project: FactoryGirl.attributes_for(:project)
        }.to change(Project,:count).by(1)
      end
      
      it "redirects to the new contact" do
        post :create, project: FactoryGirl.attributes_for(:project)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @project = FactoryGirl.create(:project, :firm => @user.firm)
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @project, project: FactoryGirl.attributes_for(:project)
      assigns(:project).should eq(@project)      
    end
  
    it "changes @project's attributes" do
      put :update, id: @project, project: FactoryGirl.attributes_for(:project, :name => "something else")
      @project.reload
      @project.name.should eq("something else")
    end
  end
  context "invalid attributes" do
    it "locates the requested @project" do
      put :update, id: @project, project: FactoryGirl.attributes_for(:project, :name => nil)
      assigns(:project).should eq(@project)      
    end
    
    it "does not change @project's attributes" do
      put :update, id: @project, 
        project: FactoryGirl.attributes_for(:project, :name => nil)
      @project.reload
      @project.name.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @project = FactoryGirl.create(:project, :firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @project        
      }.to change(Project,:count).by(-1)
    end
      
    it "redirects to contacts#index" do
      delete :destroy, id: @project
      response.should redirect_to projects_url
    end
  end
end