class BlogsController < ApplicationController
	skip_before_filter :authenticate_user!, :all_users, :user_at_current_firm
	layout "registration"
	def index
		@blogs = Blog.order(:created_at)
	end 

	def show
		@blog = Blog.find(params[:id])
	end 
end
