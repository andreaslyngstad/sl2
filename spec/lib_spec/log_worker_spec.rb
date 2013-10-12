require "./lib/log_worker.rb"
describe LogWorker do
	let(:todo) { double("Todo", save!: true) }
  let(:log) { double("Log", todo: todo, user: "user", firm: "firm", tracking: false ) }
  let(:user){ mock_model("User")}
  let(:firm){mock_model("Firm")}
	it 'should create log based on args' do
		LogWorker.create(Hash.new, true, user, firm).user.should == user 
		LogWorker.create(Hash.new, true, user, firm).firm.should == firm  
	end
	it 'should start tracking' do
		log = LogWorker.start_tracking(Hash.new, true, user, firm)
		log.user.should == user
		log.firm.should == firm 
		log.tracking.should == true
		log.log_date.should == Date.today
	end
	
	it 'should check_todo_on_log'do
		done = true
		todo.should_receive(:completed=).with(true)
		todo.should_receive(:done_by_user=).with(user)
    LogWorker.check_todo_on_log(log, user, done)
	end
	it 'unchecks todo when done is nil'do
	 	done = false
    todo.should_receive(:completed=).with(false)
    todo.should_receive(:done_by_user=).with(user)
    LogWorker.check_todo_on_log(log, user, done)
  end
  
end