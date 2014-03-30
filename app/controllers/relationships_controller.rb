class RelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		#Find the user to follow by the followed id
		@user = User.find(params[:relationship][:followed_id])
		#Have the current user follow the current user
		current_user.follow!(@user)
		#Ajax code to redirect to the same page without changing the page
		#The two lines tell the function how to respond to different format types
		#Only one line is executed
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		#Create an @user variable which is found in the Relationship table by relationship id
		#The relationship id then returns a followed id
		@user = Relationship.find(params[:id]).followed
		#Unfollow @user
		current_user.unfollow!(@user)		
		#Ajax code to redirect to the same page without changing the page
		#The two lines tell the function how to respond to different format types
		#Only one line is executed
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end
