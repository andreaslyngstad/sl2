class ProjectPrice
	def self.get_hours(project)
		project.logs.group("user").sum(:hours).map do |k,v| 
			if !k.hourly_rate.nil? 
				k.hourly_rate*v/3600
			else 
				0
			end 
		end.inject(:+).try(:round, 2) 
	end

	def self.get_cost_per_user(project)
		project.logs.group("user").sum(:hours).map {|k,v| [k.name,k.hourly_rate, v,  if !k.hourly_rate.nil?; (k.hourly_rate*v/3600).round(2); end ]}
	end

	def self.set_procentage(project)
		used = ProjectPrice.get_hours(project) || 0  
		budget =  project.budget || 0 
		if used > 0 && budget > 0
			(used / budget).round(2)
		elsif budget == 0
			"Not set"
		elsif used == 0
			"Nothing used"
		end

	end
end