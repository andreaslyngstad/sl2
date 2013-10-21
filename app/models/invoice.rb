class Invoice < ActiveRecord::Base
	belongs_to :project
	belongs_to :customer
	belongs_to :firm
	has_many 	 :logs
end
