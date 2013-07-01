class LogsController < ApplicationController
  def index 
    @logs = current_firm.logs.where(:log_date => Date.today).order("updated_at DESC").includes({:project => [:users, :firm]} , :todo, :firm, :user, :customer, :employee)
    if !current_user.logs.blank?
      @log = current_user.logs.where("end_time IS ?",nil).last
      if @log.nil?
         @log_new = Log.new
      end
 	  else
 	    @log_new = Log.new
 	  end
  end

  def edit
    @log = Log.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @klass = LogWorker.create(params[:log], check_done(params[:done]), current_user, current_firm)
    create_resonder(@klass)
  end

  def update
  	@klass = Log.find(params[:id])
    @pre_hours = @klass.time   
    LogWorker.check_todo_on_log(@klass, current_user, check_done(params[:done])) if !@klass.todo.nil?
    update_responder(@klass,params[:log])
  end
 
  def destroy
    @log = Log.find(params[:id])
    @log.destroy
    respond_to do |format|
      flash[:notice] = flash_helper('Log was deleted.')
      format.js
    end
  end

  def start_tracking
    @log = LogWorker.start_tracking(params[:log], check_done(params[:done]), current_user, current_firm)
    create_resonder(@log)
  end

  def stop_tracking
    @log_new = Log.new
  	@log = Log.find(params[:id])
    @log.end_time = Time.now
	  LogWorker.check_todo_on_log(@log, current_user, check_done(params[:done])) unless @log.todo.nil? 
	  update_responder(@log,params[:log])
  end
  
  def get_logs_todo
    @todo = Todo.find(params[:todo_id])
    @logs = @todo.logs
    respond_to do |format|
      format.js
    end
  end
private
  def check_done(done)
    done == "1"
  end

  def create_resonder(log) 
     respond_to do |format|
      if log.save
        flash[:notice] = flash_helper('Log was successfully saved.')
        format.js
      else
       format.js { render "shared/validate_create" }
      end 
    end
  end

  def update_responder(log, params)
    respond_to do |format|
      if log.update_attributes!(params)
        flash[:notice] = flash_helper("Log was successfully saved.")
        format.js
      else
        format.js { render "shared/validate_update" }
        
      end
    end
  end
end