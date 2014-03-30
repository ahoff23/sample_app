#Spec test for the user pages (VIEWS)
require 'spec_helper'

#Make sure that the singup page has title and content containing 'Sign up'
describe "User Pages" do
  subject { page }

  #Test for index view content
  describe "index" do
    #Create a FactoryGirl
    let(:user) { FactoryGirl.create(:user) }
    #Before each test, sign the user in and go to the users path
    before(:each) do
      sign_in user
      visit users_path
    end

    #Make sure title and basic content are functional
    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      #Before all tests in "pagination" block, create 30 users
      before(:all)  { 30.times { FactoryGirl.create(:user)} }
      #At the end of the block, delete all users
      after(:all)   { User.delete_all }

      #It should have a pagination bar somewhere on the page
      it { should have_selector('div.pagination') }

      #Go through each page, and you should find one instance of the user's name
      #in a list item, 'li'
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    #Tests for delete links on the index page
    describe "delete links" do
      #user is currently not an admin, so the user should not see any delete buttons
      it { should_not have_link('delete') }

      describe "as an admin user" do
        #Create a user variable, admin, which has its admin attribute set to true
        let(:admin) { FactoryGirl.create(:admin) }
        #Sign the admin in and go to the index page
        before do
          sign_in admin
          visit users_path
        end

        #There should be a link called delete which links to the first user show page
        it { should have_link('delete', href: user_path(User.first)) }

        #Click the delete button and make sure the User count decreases by 1
        it "should be able to delete another user" do
          expect do
            #Click the first delete link on the page
            click_link('delete', match: :first)
          #Expect the User count to decrease by one at the end of the expect block
          end.to change(User, :count).by(-1)
        end
        #Make sure the admin does not have a delete button for itself
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

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

    #Create two microposts immediately with let! so that they appear when viewing
    #the show page (otherwise they would not be created until they were referenced)
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }

    #Make sure the page displays the microposts
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      #Also ennsure that the number of microposts the user has is displayed
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do 
      #Create an other_user
      let(:other_user) { FactoryGirl.create(:user) }
      #Sign user in
      before { sign_in user }

      describe "following a user" do
        #Go to other user's show page
        before { visit user_path(other_user) }

        it "should increment the other user's following count" do
          #Click the "Follow" button
          #Expect to change the other_user's followers by 1
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        it "should increment the followed user count" do
          #Click the "Follow" button
          #Expect to change the user's following count by 1
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          #Click the follow button should create a new input possibility, 'Unfollow'
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        #Set the user to follow other_user
        #Visit the other_user's show page
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          #Click the Unfollow button and expect the number 
          #of user's user follows to decrease
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          #Click the Unfollow button and expect the number 
          #of followers of other_use to decrease
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          #Click the unfollow button
          before { click_button "Unfollow" }
          #A new input should be possible, 'Follow'
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
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
        fill_in "Name",             with: "Example User"
        fill_in "Email",            with: "user@example.com"
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "foobar"
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
        fill_in "Password",         with: "foobar"
        fill_in "Confirm Password", with: "Foobar"
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

      #Fill in the fields again with the same email address and submit
      before do
        fill_in "Name",         with: user.name
        fill_in "Email",        with: user.email
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
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

  #********************************************************
  #EDIT USER INFORMATION TESTS
  #********************************************************

  describe "edit" do
    #Create a user in the database 
    let(:user) { FactoryGirl.create(:user) }
    #Sign the user in. Users should not be able to edit information without
    #signing in beforehand
    before do 
      sign_in user 
      #Go to edit user page
      visit edit_user_path(user)
    end

    #Can't change the 'admin' attribute 
    describe "forbidden attributes" do
      #Create a params variable to pass to the user update function
      let(:params) do
        { user: { admin: true, password: user.password, password_confirmation: user.password } }
      end

      #Sign the user in and set capybara to false (capybara doesn't allow patch requests)
      before do
        sign_in user, no_capybara: true
        #Call the UPDATE function with params, this is how you update a user without
        #using a view/form
        patch user_path(user), params
      end
      #Expect admin to still be false (it was initially false because you used create(:user))
      specify { expect(user.reload).not_to be_admin }
    end

    #Basic page display tests
    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      #Link for changing gravatar image
      it { should have_link('change', href:'http://gravatar.com/emails') }
    end

    #Input invalid information (i.e. nothing) and make sure an error is printed
    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with valid information" do
      #Create variables for a new name and email
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      #Edit the user data and submit (password is the same as before!)
      before do
        fill_in "Name",              with: new_name
        fill_in "Email",             with: new_email
        fill_in "Password",          with: user.password
        fill_in "Confirm Password",  with: user.password
        click_button "Save changes"
      end

      #Redirect to user page i.e. updated name as title
      it { should have_title(new_name) }
      #Flash signifying successful information change
      it { should have_selector('div.alert.alert-success') }
      #Make sure the user is still logged in
      it { should have_link('Sign out', href: signout_path) }
      #Reload the user name and email and make sure they match the name
      #and email in the input data
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

  describe "following/followers" do
    #Create a user and an other user to be followed by user
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    #Have user follow other user
    before { user.follow!(other_user) }

    describe "followed users" do
      #Sign in the user and visit the following (i.e. users the user follows) users page of user
      before do
        sign_in user
        visit following_user_path(user)
      end
      #The title should have full_title('Following')
      it { should have_title(full_title('Following')) }
      #The page should have a selector heading 3 fand the text 'Following'
      it { should have_selector('h3', text: 'Following') }
      #The page should have a link titled with the other user's name that link's to the other user's show page
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      #Sign the other user in and then visit its followers page
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end
      #The title should have full_title('Followers')
      it { should have_title(full_title('Followers')) }
      #The page should have a selector heading 3 for the Followers page
      it { should have_selector('h3', text: 'Followers') }
      #The page should have a link titled with user's name that link's to the other user's show page
      it { should have_link(user.name, href: user_path(user)) }
   end
 end
end