module SessionsHelper

	def sign_in(user)
		#Create a variable, remember_token, that calls the given function in the session helper
		remember_token = User.new_remember_token
		#Place the remember token in the browser cookies
		#.permanent actually is .20.years.from_now
		cookies.permanent[:remember_token] = remember_token
		#Update the user's token with the newly created remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		#Set the current_user of the session to the user passed as a parameter
		self.current_user = user
	end

	#Define a current user and set it to the parameter
	#This actually a function (somewhat like operator overloading) because
	#it simply makes the function of form current_user(...) equivalent
	#to current_user=(...), which is easier to read
	def current_user=(user)
		@current_user = user
	end

	#Returns the current user
	#Create a variable equal to the user with the same remember_token
	#The ||= is an 'or equals' operator. It sets @current_user to the RHS only if
	#@current_user is not already defined. Only useful if current_user is called more
	#than once for a single request. Still called on every page.
	def current_user
		#Encrypt the remember_token currently in the browser
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	#Boolean function which returns true if current_user
	#(which is actually just the return value of the function current_user)
	#exists and returns false if current_user returns nil
	def signed_in?
		!current_user.nil?
	end

	#Sign user out
	def sign_out
		#Change the user's remember_token in the database in case it was stolen
		current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
		#Delete the remember_token stored as a cookie
		cookies.delete(:remember_token)
		#Set current_user to nil so it fails signed_in? function in sessions helper
		#Not necessary because the destroy action redirects the view to the homepage, but
		#this is necessary without a redirect
		self.current_user = nil
	end

	#Returns true if parameter user is equal to the current_user, otherwise return false
	def current_user?(user)
		user == current_user
	end

	#Before edits or updates, make sure user is signed in
  	def signed_in_user
		unless signed_in?
	    	#If the user is not signed in, store the location of the most recent GET request
	      	#which means that store location will do nothing for an update PATCH
	      	store_location
	      	redirect_to signin_url, notice: "Please sign in." 
	    end
  	end	

  #********************************************************
  #FRIENDLY REDIRECT
  #********************************************************
  #Redirect back to the stored location 'return_to' or the default if 'return_to'
  #does not exist
  def redirect_back_or(default)
  	redirect_to(session[:return_to] || default)
  	#Delete the stored location because it has already been redirected to
  	#If you do not include this, any further sign ins before browser close will redirect
  	#to the stored location
  	session.delete(:return_to)
  end

  #Store the return location in a hash of the session object
  def store_location
  	#Store the request url if it exists (only for a GET request because you do not 
  	#want to redirect to a user update, the user should have to re-enter information)
  	session[:return_to] = request.url if request.get?
  end
end