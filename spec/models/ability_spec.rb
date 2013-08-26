require 'spec_helper'
 
describe Ability do
	let(:firm)					{ FactoryGirl.create(:firm)}
  let(:admin_user) 		{ FactoryGirl.create(:user, role: "Admin", firm: firm) }
  let(:member_user) 	{ FactoryGirl.create(:user, role: "Member", firm: firm) }
  let(:external_user) { FactoryGirl.create(:user, role: 'External user', firm: firm) }

  it { Ability.should include(CanCan::Ability) }
  it { Ability.should respond_to(:new).with(1).argument }
 
  context "admin" do
 
    it "can manage all" do
      Ability.any_instance.should_receive(:can).with(:manage, Firm)
      Ability.any_instance.should_receive(:can).with(:manage, User, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Customer, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Project, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:create, Project )
      Ability.any_instance.should_receive(:can).with(:archive, Project)
      Ability.any_instance.should_receive(:can).with(:activate_projects, Project)
      Ability.any_instance.should_receive(:can).with(:manage, Log, :firm => {:id => admin_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Todo, :firm => {:id => admin_user.firm_id})
      Ability.new admin_user
    end
  end
 
  context "Member" do
   
    it "can not manage all" do
    	Ability.any_instance.should_receive(:can).with(:read, Firm)
      Ability.any_instance.should_receive(:can).with(:manage, User )
      Ability.any_instance.should_receive(:can).with(:manage, Customer, :firm => {:id => member_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:read, Project, :firm => {:id => member_user.firm_id})
      Ability.any_instance.should_receive(:can).with(:manage, Todo )
      Ability.any_instance.should_receive(:can).with(:manage, Project )
      Ability.any_instance.should_receive(:can).with(:create, Project )
      Ability.any_instance.should_receive(:cannot).with(:archive, Project)
      Ability.any_instance.should_receive(:cannot).with( :activate_projects, Project)
      Ability.any_instance.should_receive(:can).with(:manage, Log )
      Ability.any_instance.should_receive(:can).with(:read, Log, :firm => {:id => member_user.firm_id})
      Ability.new member_user
    end
  end
 	context "Member" do
    it "can create and edit models" do
      Ability.any_instance.should_receive(:can).with(:read, Project )
      Ability.any_instance.should_receive(:can).with(:manage, Todo)
      Ability.any_instance.should_receive(:cannot).with(:archive, Project)
      Ability.any_instance.should_receive(:can).with(:manage, Log )
      Ability.any_instance.should_receive(:can).with( :read, Log )
      Ability.new external_user
   end
  end
end