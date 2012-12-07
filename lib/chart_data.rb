require "symbol.rb"
class ChartData
  attr_accessor :firm, :range, :model
  def initialize(firm,range,model)
    @firm = firm
    @range = range
    @model = model  
  end
  
  def logs_by_day(logs)
    days_with_hours = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}
      logs.each do |log|
        if log.total_hours > 10.0
        if log.send(@model) 
          days_with_hours[log.send(@model).name][log.log_date] = log.total_hours
        else
          days_with_hours["No " + @model.to_s][log.log_date] = log.total_hours
        end
      end
      end
   
    days_with_hours
    
  end
  
  def chart_lables
    @firm.send(@model.pluralize).map do |model_instance|
       model_instance.name.gsub(/["]/, "'")  
    end
  end
  
  def all_dates_no_hours
    ms = []
    ms << "No " + @model.to_s
    models = ms + chart_lables
    
    date_hours_empty = Hash.new{|h, k| h[k] = Hash.new(&h.default_proc)}      
    models.each do |m|
      (@range).each do |day|
      date_hours_empty[m][day] = 0
      end
    end
    date_hours_empty
  end
  
  def compile_hash
   key_user_value_date_hours = Hash.new
   emtpy_hours = all_dates_no_hours
   log_hours = logs_by_day(Log.hours_by_day_and_model(@firm, @range, @model))
   emtpy_hours.each do |k,v|
     if log_hours.has_key?(k)
      c = log_hours.values_at(k)[0].diff(emtpy_hours.values_at(k)[0])
      key_user_value_date_hours[k] = c 
     end   
   end 
    key_user_value_date_hours
   end
   
  def stacked
    key_user_value_date_hours = compile_hash
    output = '[' 
    key_user_value_date_hours.each do |name,dates|
      output << '{ "key" : "' + name.gsub("\n", "") + '", ' 
      output << '"values" : [' 
      dates.sort_by{|k,v| k}.each do |date|
        output << '[' + (Time.parse("#{date[0]}").to_i * 1000).to_s + ',' + TimeHelp.new.time_to_hours_test(date[1]).to_s + '],'
      end 
      output.chomp!(',') 
      output << ']},'
    end
    output.chomp!(',')
    output << ']'
  end 
  
  def pie
    logs = Log.hours_by_model(@firm, @range, @model)
    output = '[{ "key": "pie", "values": ['
    logs.each do |log|
      if !log.send(model).nil?
        output << '{ "label" : "' + log.send(model).name.gsub("\n", "") + '",'
      else
        output << '{ "label" : "No ' + model.to_s + '",'
      end
       log.total_hours < 10.0 ? output << '"value" : 0.01},': output << '"value" : ' + TimeHelp.new.time_to_hours_test(log.total_hours).to_s + '},'
    end
    output.chomp!(',')
    output << ']}]'
  end 
end