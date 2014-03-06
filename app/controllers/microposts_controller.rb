class MicropostsController < ApplicationController
	before_action :signed_in_user, 	only: [:create, :destroy]
	before_action :correct_user,	only: [:destroy]

	def create
		@micropost = current_user.microposts.build(micropost_params)

		if @micropost.save
			flash[:success] = "Micropost created!"
			redirect_to root_url
		else
			#_feed.html.erb has the line <% if @feed_items.any? %> which fails without any @feed_items because it is calling
			#a function on a non-exiistant instance variable, so upon failure, create an empty @feed_items,
			#which will fail the if statement anyway
			#ERROR: THIS MAKES THE MICROPOST FEED BLANK
			@feed_items = current_user.feed.paginate(page: params[:page])
			render 'static_pages/home'
		end
	end

	def destroy
		#Destroy the @micropost variable
		@micropost.destroy
		#Redirect to the homepage view
		redirect_to root_url
	end

	private

	def micropost_params
		params.require(:micropost).permit(:content)
	end

	def correct_user
		#Create a micropost variable for the current_user by searching for the micropost id
		#User find_by because it returns nil if the micropost is not found, not an exception
		@micropost = current_user.microposts.find_by(id: params[:id])
		#Redirect to the homepage if the micropost does not exist
		#(i.e. if the micropost's id was not found in the current user's matrix)
		redirect_to root_url if @micropost.nil?
	end
end