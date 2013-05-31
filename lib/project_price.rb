class ProjectPrice
	def self.get_hours(project)
		project.logs.group("user").sum(:hours).map {|k,v| k.hourly_rate*v/3600}.inject(:+)
	end

	def self.set_procentage(project)
		used = ProjectPrice.get_hours(project) || 0
		budget =  project.budget || 0
		(used / budget).round(2)
	end
end