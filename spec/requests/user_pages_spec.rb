#Spec test for the user pages (VIEWS)
require 'spec_helper'

#Make sure that the singup page has title and content containing 'Sign up'
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

      #Make sure the app works when you input valid information
      #and hit the submit button i.e. flash and redirect work
      describe "after saving the user" do
        before { click_button submit }
        #Create a user with the same email address as the one
        #created in the before block
        let(:user) { User.find_by(email: 'user@example.com') }

        #Make sure the user's name is in the title and the
        #Make sure the right CSS class and associated text are on
        #the new page
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        #Make sure the user is signed in after signing up
        it { should have_link('Sign out') }
      end
    end
  end

  #********************************************************
  #ERROR MESSAGE TESTS
  #********************************************************
  describe "should display an error with" do
    #Visit the signup page
    before { visit signup_path }
    
    #Create a submit button variable
    let(:submit) { "Create my account" }
    
    #Error message should display when no fields are filled in
    describe "empty fields" do
      before { click_button submit }
      it { should have_content('error') }
    end

    #Error message should display when the password is too short
    describe "a password of 5 characters" do
      before do
        fill_in "Password",   with: "foo"
      end

      before { click_button submit }
      it { should have_content('Password is too short (minimum is 6 characters)') }
    end

    #Error message should display when password and password 
    #confirmation do not match (case sensitive test)
    describe "password/confirmation mismatch" do
      before do
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "Foobar"
      end

      before { click_button submit }
      it { should have_content('Password confirmation doesn\'t match Password') }
    end

    #Create two users with the same email address and make sure an
    #an error message is displayed
    describe "already used email address" do
      #Go back to the signup page to sign another user in
      before { visit signup_path }
      #Create a user variable through a Factory
      let(:user) { FactoryGirl.create(:user) }

      #Create an account for a user with valid information
      before { valid_signup(user) }

      #Fill in the fields again with the same email address and submit
      before do
        fill_in "Name",         with: user.name
        fill_in "Email",        with: user.email
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end
      before { click_button submit }
      it { should have_content('Email has already been taken') }
    end

    #Create a 51 character username, which should return an error
    describe "51 character username" do
      before do
        fill_in "Name",         with: "a" * 51
      end
      before { click_button submit }
      it { should have_content('Name is too long (maximum is 50 characters)') }
    end

    #Using an invalid array of emails, report an error for each
    describe "an invalid email" do
      addresses = %w[user@foo,com userfoo.com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        before do
          fill_in "Email",        with: invalid_address
        end
        before { click_button submit }
        it { should have_content('Email is invalid') }
      end
    end
  end
end