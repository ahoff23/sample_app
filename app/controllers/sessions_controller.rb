class SessionsController < ApplicationController

def new
end

def create
	#Find the user based on the email in the parameter field
	user = User.find_by(email: params[:session][:email].downcase)
	#If the user exists in the database AND the email address matches the password
	if user && user.authenticate(params[:session][:password])
			#sign user in and redirect to their user page
			sign_in user
			#When using redirect, redirecting to variable object name
			#redirects the viewer to the 'show' function of that object
			#unless a protected page was attempted to be viewed, in which case it will
			#redirect to the stored page
			redirect_back_or user
	else
		#Send a flash error
		flash.now[:error] = 'Invalid email/password combination'
		#Redirect to the signin page
		render 'new'
	end
end

def destroy
	sign_out
	redirect_to root_url
end

end