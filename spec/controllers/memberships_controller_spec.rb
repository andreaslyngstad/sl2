require 'spec_helper'

describe MembershipsController do
	login_user
  
  before(:each) do
    @request.host = "#{@user.firm.subdomain}.example.com" 
  end
  describe "index" do
  	let(:firm) 					{@user.firm}
    let(:project)       {FactoryGirl.create(:project, firm:firm)}
  	let(:external_user) {FactoryGirl.create(:user, firm: firm, role: "External user")}
	  

    it "assigns user to project" do
      post :index, id: external_user.id, project_id: project.id, format: [:js]
      assigns(:project).should == project
      assigns(:user).should == external_user
      project.users.should include external_user
      flash[:notice].should == "<span style='color:#FFF'>#{external_user.name} is a member of the #{project.name} project.</span>"
    end
	  it "removes user from project" do
      project.users << [external_user, @user]
      project.users.count.should == 2
      post :index, id: external_user.id, project_id: project.id, format: [:js]
      assigns(:project).should == project
      assigns(:user).should == external_user
      project.users.include?(external_user).should == false
      project.users.count.should == 1
      flash[:notice].should == "<span style='color:#FFF'>#{external_user.name} is NOT a member of the #{project.name} project.</span>"
	  end
    it "assigns user to project" do
      project.users << [external_user]
      @user.role = "Member"
      @user.save
      post :index, id: external_user.id, project_id: project.id, format: [:js]
      assigns(:project).should == project  
      flash[:notice].should == "<span style='color:#FFF'>Access denied.</span>"
    end
  end
end
