require 'spec_helper'
# let(:user) { create(:user) }
  # before { login_as user }
describe MilestonesController do 

  login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com"
    @project = FactoryGirl.create(:project, :firm => @user.firm)
  end
  
  describe "POST create" do
    context "with valid attributes" do
      it "creates a new contact" do
        expect{
          post :create, milestone: FactoryGirl.attributes_for(:milestone, :project_id => @project.id)
        }.to change(Milestone,:count).by(1)
      end
      it "Gives a flash notice" do
        post :create, milestone: FactoryGirl.attributes_for(:milestone, :project_id => @project.id)
        flash[:notice].should_not be_nil 
      end
    end 
  end
  describe 'PUT update' do
  before :each do
    @milestone = FactoryGirl.create(:milestone, :project_id => @project.id , :firm => @user.firm)
    
  end
  
  context "valid attributes" do
    it "located the requested @contact" do
      put :update, id: @milestone, milestone: FactoryGirl.attributes_for(:milestone, :project_id => @project.id)
      assigns(:milestone).should eq(@milestone)      
    end
  
    it "changes @milestone's attributes" do
      put :update, id: @milestone, milestone: FactoryGirl.attributes_for(:milestone, :goal => "something else", :project_id => @project.id)
      @milestone.reload
      @milestone.goal.should eq("something else")
      flash[:notice].should_not be_nil 
    end
  end
  context "invalid attributes" do
    it "locates the requested @milestone" do
      put :update, id: @milestone, milestone: FactoryGirl.attributes_for(:milestone, :goal => nil)
      assigns(:milestone).should eq(@milestone)      
    end
    
    it "does not change @milestone's attributes" do
      put :update, id: @milestone, 
        milestone: FactoryGirl.attributes_for(:milestone, :goal => nil)
      @milestone.reload
      @milestone.goal.should_not eq("something else")
    end
  end
  
end
  describe 'DELETE destroy' do
    before :each do
      @milestone = FactoryGirl.create(:milestone, :project_id => @project.id, :firm => @user.firm)
    end
    
    it "deletes the contact" do
      expect{
        delete :destroy, id: @milestone       
      }.to change(Milestone,:count).by(-1)
    end
  end
end