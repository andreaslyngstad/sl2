
	
class QueueFix < QC::Queue
  	
	def count2
    QC.log_yield(:measure => 'queue.count') do
      s = "SELECT COUNT(*) FROM #{TABLE_NAME} WHERE q_name = $1"
      r = conn.execute(s, name)
      r["count"].to_i
    end
  end
end
