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