require 'spec_helper'

describe "Authentication" do
	subject { page }

	#Basic title and content information test
	describe "signin page" do
		before { visit signin_path }
		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
	end

	describe "signin" do
		before { visit signin_path }

		#Test test make sure signing in with no informaton returns an error
		describe "with invalid information" do
			before { click_button "Sign in" }
			#Make sure the page redirects back to the sign in page
			it { should have_title('Sign in') }
			#Make sure an error message is displayed (Flash)
			it { should have_selector('div.alert.alert-error') }

			#Make sure the error does not persist after one page
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
		end

		#Test that valid information works properly
		describe "with valid information" do
			#Use FactoryGirl when you are creating an object of a
			#resource which would normally already exist in the database
			let(:user) { FactoryGirl.create(:user) }
			#Fill in the fields with accurate information and click submit
			before do
				#Use upcase on the email to ensure that emails
				#are case insensitive (Remember, emails are saved downcase)
				fill_in "Email", 		with: user.email.upcase
				fill_in "Password", 	with: user.password
				click_button "Sign in"
			end

			#New page title should be the user's name	
			it { should have_title(user.name) }
			#New page should contain a link to the user's profile page
			#i.e. user/:id
			it { should have_link('Profile',		href: user_path(user)) }
			#New page should have a link to sign out
			it { should have_link('Sign out',		href: signout_path) }
			#New page should not have a link to sign in
			it { should_not have_link('Sign in', 	href: signin_path) }

			#Sign the user out and ensure that signout succeeded
			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
		end
	end
end