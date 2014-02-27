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
			#Sign user in
			before { sign_in user }

			#New page title should be the user's name	
			it { should have_title(user.name) }
			#Header should contain a link to the 'Users' path i.e. users index
			it { should have_link('Users',			href: users_path) }
			#New page should contain a link to the user's profile page
			#i.e. user/:id
			it { should have_link('Profile',		href: user_path(user)) }
			#Signed in users have a settings link that links to the edit user page
			it { should have_link('Settings',		href: edit_user_path(user)) }
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

	#Tests for accessing pages when you are or are not the correct user
	describe "authorization" do
		#Users may not update or edit another user's information
		describe "as wrong user" do
			#Create a user and an incorrect user
			let(:user) { FactoryGirl.create(:user) }
			#This FactoryGirl takes an additional parameter, a manually inputted email
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			#Sign the correct user in WITHOUT CAPYBARA (test with to see if that works)
			before { sign_in user, no_capybara: true }

			#Edit action for incorrect user fails
			describe "submitting a GET request to the Users#edit action" do
				#GET request for the edit action
				before { get edit_user_path(wrong_user) }
				#Do not expect the page to go to the edit user view
				#Written strangely because capybara is not used
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				#Expect the page to redirect to the homepage
				specify { expect(response).to redirect_to(root_url) }
			end

			#Submitting a patch request for the user#update action fails
			#i.e. clicking the submit button on the edit user page
			describe "submitting a PATCH request to the Users#update action" do
				#PATCH request to update user
				before { patch user_path(wrong_user) }
				#Should redirect to homepage
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		#Prevent access to certain pages if the user is not signed in
		describe "for non-signed-in users" do
			#Create a temporary user
			let(:user) { FactoryGirl.create(:user) }

			#If a user goes to a protected page without signing in, redirect them
			#to the sign in page, allow them to sign in, and then redirect them
			#to their intended destination, the edit user page
			describe "when attempting to visit a protected page" do
				#Visit the edit page (remember, there has not been a sign in yet)
				#fill in the email and password fields and click the sign in button
				before do
					#Visit the edit_user_path, which should redirect to the sign in page
					visit edit_user_path(user)
					#Sign in
					fill_in "Email",		with: user.email
					fill_in "Password",		with: user.password
					click_button "Sign in"
				end

				#After signing in, the user should be redirect to the proper
				#edit user page
				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end
				end
			end

			describe "in the Users controller" do

				#Non-signed in users should not be able to edit user information
				describe "visiting the edit page" do
					#Visit the edit page
					before { visit edit_user_path(user) }
					#Should redirect to sign in page
					it { should have_title('Sign in') }
				end


				describe "submitting to the update action" do
					#Update the user by patching the update action (can't visit with Capybara)
					before { patch user_path(user) }
					#Make sure the server redirects to the sign in page
					specify { expect(response).to redirect_to(signin_path) }
				end

				#Users who are not signed in cannot view the users index
				describe "visintg the user index" do
					before { visit users_path }
					it { should have_title('Sign in') }
				end
			end

			#Non-admin users should not be able to issue DELETE commands
			describe "as non-admin user" do
				#Create a user to delete
				let(:user) { FactoryGirl.create(:user) }
				#Create a non-admin user to attemtpt to delete user
				let(:non_admin) { FactoryGirl.create(:user) }

				before { sign_in non_admin, no_capybara: true }

				#Delete the user and expect a redirect to the homepage
				describe "submitting a DELETE request to the user#destroy action" do
					before { delete user_path(user) }
					specify { expect(response).to redirect_to(root_url) }
				end
			end
		end
	end
end