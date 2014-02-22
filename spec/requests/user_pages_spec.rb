#Spec test for the user pages (VIEWS)
require 'spec_helper'

describe "User Pages" do
  	subject { page }

	describe "signup page" do
    	before { visit signup_path }

    	it { should have_content('Sign up') }
    	it { should have_title(full_title('Sign up')) }
  end

	#Test for the user profile page
	#Ensure that the title contains the username
	#Ensure that the content includes the username
	describe "profile page" do
    #Create a user variable through a Factory
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }
	end

  #Tests which submit information on the signup page and
  #ensure that valid information creates a new user and
  #invalid data does not create a new user
  describe "signup" do
    #Visit the signup page
    before { visit signup_path }

    #Create a submit button variable
    let(:submit) { "Create my account" }

    #Do not fill in the information fields and click submit (invalid data)
    describe "with invalid information" do
      #Test desription
      it "should not create a user" do
        #Click the button then check that the user count does not change
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    #Fill the information fields with valid information
    #then check to make sure that the user count increases
    describe "with valid information" do
      #Fill in the fields
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      #Check that pressing submit increases the User count by 1
      it "should create a user" do
        expect { click_button submit }.to change(User,:count).by(1)
      end
    end
  end
end