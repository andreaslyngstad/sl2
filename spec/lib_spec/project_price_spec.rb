describe ProjectPrice do 
		let(:time)		{Time.now}
		let(:firm)		{FactoryGirl.create :firm}
		let(:project) 	{FactoryGirl.create :project, firm: firm, budget:10 }
		let(:bob)		{FactoryGirl.create :user, name: "bob", hourly_rate: 2, firm: firm }
		let(:alice) 	{FactoryGirl.create :user, name: "alice", hourly_rate: 1, firm: firm }
		let(:joice) 	{FactoryGirl.create :user, name: "joice", hourly_rate: nil, firm: firm }
		let(:log1)		{FactoryGirl.create :log, event: "test", project: p,begin_time: time, end_time: time + 2.hours, user: bob, firm: firm }
		let(:log2)		{FactoryGirl.create :log, event: "test2", project: p, begin_time: time, end_time: time + 1.hours,user: alice, firm: firm }
		let(:log3)		{FactoryGirl.create :log, event: "test2", project: p, begin_time: time, end_time: time + 3.hours,user: joice, firm: firm }
	before(:all) do
		project.users << [alice, bob, joice]
		project.logs << [log1, log2, log3]
	end	
	it "Should get all hours on project grouped by user" do		
		expect(ProjectPrice.get_hours(project)).to eq(5) 
	end
	it "Should set the procentage of budget spent" do
		ProjectPrice.get_cost_per_user(project).should =~ [["joice", nil, 10800.0, nil], ["bob", 2.0, 7200.0, 4.0], ["alice", 1.0, 3600.0, 1.0]]
	end
	it "Should set the procentage of budget spent" do
		ProjectPrice.set_procentage(project).should == 0.5 
	end
end   