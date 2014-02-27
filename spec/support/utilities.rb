def full_title(page_title)
	base_title = "Ruby on Rails Tutorial Sample App"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def valid_signup(user)
  #Fill in the fields with valid data and click submit
  fill_in "Name",         with: user.name
  fill_in "Email",        with: user.email.upcase
  fill_in "Password",     with: "foobar"
  fill_in "Confirmation", with: "foobar"

  click_button submit
end

#Sign a user in, second param can be passed as: 'no_capyabara: true' when not using capybara
def sign_in(user, options={})
	#Sign in when not using Capybara
	if options[:no_capybara]
		#Create a new token
		remember_token = User.new_remember_token
		#Set the remember_token stored in cookies
		cookies[:remember_token]=remember_token
		#Update the user's remember_token to  match the one stored in cookies
		user.update_attribute(:remember_token,User.encrypt(remember_token))
	else
		visit signin_path
		fill_in "Email", 	with: user.email
		fill_in "Password", with: user.password
		click_button "Sign in"
	end
end