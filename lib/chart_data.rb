class ChartData
  
  def self.user_logs_by_day(logs)
    days_with_hours = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}
      logs.each do |log|
        days_with_hours[log.user.name][log.log_date] = log.total_hours
      end
    days_with_hours
  end
  
  def self.project_logs_by_day(logs)
    days_with_hours = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}
      logs.each do |log|
        if !log.project.nil?
          days_with_hours[log.project.name][log.log_date] = log.total_hours
        else
          days_with_hours[@default][log.log_date] = log.total_hours
        end
      end
    days_with_hours
  end
  
  def self.all_dates_all_no_hours(firm, range, model)
    if model == "user"
      models = User.chart_user_lables(firm)
    elsif model == "project"
       @default = "No project"
      models = Project.chart_project_lables(firm)
      models << @default
    end
    date_hours_empty = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}      
    models.each do |m|
      (range).each do |day|
      date_hours_empty[m][day] = 0
      end
    end
    date_hours_empty
  end
  
  def self.compile_hash(firm, range, model)
   key_user_value_date_hours = Hash.new
   if model == "user"
   emtpy_hours = all_dates_all_no_hours(firm,range,model)
   log_hours = user_logs_by_day(Log.hours_by_day_and_user(firm, range))
   elsif model == "project"
   emtpy_hours = all_dates_all_no_hours(firm,range,model)
   log_hours = project_logs_by_day(Log.hours_by_day_and_project(firm, range))
   end
   emtpy_hours.each do |k,v|
     if log_hours.has_key?(k)
      c = log_hours.values_at(k)[0].diff(emtpy_hours.values_at(k)[0])
      key_user_value_date_hours[k] = c 
     end   
   end 
    key_user_value_date_hours
   end
   
  def self.user_logs_json_out(firm, range, model)
    key_user_value_date_hours = compile_hash(firm, range, model)
    output = "[" 
    key_user_value_date_hours.each do |name,dates|
      output << "{ 'key' :" + "'" + name + "',"
      output << "'values' : [" 
      dates.sort_by{|k,v| k}.each do |date|
        output << "[" + (Time.parse("#{date[0]}").to_i * 1000).to_s + "," + TimeHelp.new.time_to_hours_test(date[1]).to_s + "],"
      end  
      output << "]},"
    end
    output << "];"
  end 
  def self.project_pie_logs(firm, range)
    logs = Log.hours_by_project(firm, range)
    output = "[{ key: 'Cumulative Return', values: ["
    logs.each do |log|
      if !log.project.nil?
        output << "{ 'label' :'" + log.project.name + "',"
      else
        output << "{ 'label' :'" + @default + "',"
      end
      output << "'value' : " + TimeHelp.new.time_to_hours_test(log.total_hours).to_s + "},"
    end
    output << "]}]"
  end
  def self.user_pie_logs(firm, range)
    logs = Log.hours_by_user(firm, range)
    output = "[{ key: 'Cumulative Return', values: ["
    logs.each do |log|
      output << "{ 'label' :'" + log.user.name + "',"
      output << "'value' : " + TimeHelp.new.time_to_hours_test(log.total_hours).to_s + "},"
    end
    output << "]}]"
  end
 
end