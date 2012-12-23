module LogWorker
  extend self
  def create(params, done, user, firm)
    log      = Log.new(params)
    unless log.user
    log.user = user
    end
    log.firm = firm
    log.tracking = false
    if log.todo
      check_todo_on_log(log, done)
    end
    log
  end
  
  def start_tracking(log,done,user,firm)
    log = LogWorker.create(log,done,user,firm)
    log.tracking = true
    log.begin_time = Time.now
    log.log_date = Date.today
    log
  end
  
  def check_todo_on_log(log, done)
    if done == "1"
         log.todo.completed = true
         log.todo.save!
    elsif done.nil?
         log.todo.completed = false
         log.todo.save!
    end
  end 
end