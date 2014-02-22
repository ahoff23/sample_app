#Spec test for the User model (i.e. actual users, not views)
require 'spec_helper'

describe User do

	#SAMPLE USER
	#Before, create a sample User, @user
	before do
		@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
	end
  	
  	#SET SUBJECT FOR TESTS
  	#Set the subjecto of further test to @user
  	subject { @user }

  	#PARAMETER EXISTANCE TESTS
  	#Test to make sure @user has a :name and :email hash
  	it { should respond_to(:name) }
  	it { should respond_to(:email) }
  	#Test to make sure @user has an encrypted password
  	it { should respond_to(:password_digest) }
  	#Test to make sure @user has a password and a confirmation password
  	it { should respond_to(:password) }
  	it { should respond_to(:password_confirmation) }

  	#Test the validity of @user
  	it { should be_valid }

  	#FORMATTING RESTRICTIONS

  	#Test to make sure that @user has a name 
  	#i.e. :name!=" " and :name!=nil
  	describe "when name is not present" do
  		before { @user.name = " " }
  		it { should_not be_valid }
  	end

  	#Test a name of 51 characters to make sure that name length is lmiited to 50 characters
  	describe "when name is too long" do
  		before { @user.name = "a" * 51 }
  		it { should_not be_valid }
  	end

  	#Test to make sure that @user has an email
  	describe "when email address is not present" do
  		before { @user.email = " " }
  		it { should_not be_valid }
  	end

  	#Test an array of invalid email addreses to ensure that 
  	#they are rejected
  	describe "when email format is invalid" do
  		it "should be invalid" do
  			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
  			addresses.each do |invalid_address|
  				@user.email = invalid_address
  				expect(@user).not_to be_valid
  			end
  		end
  	end

  	#Test an array of valid email addresses to ensure that they
  	#are not rejected
  	describe "when email format is valid" do
  		it "should be valid" do
  			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  			addresses.each do |valid_address|
  				@user.email = valid_address
  				expect(@user).to be_valid
  			end
  		end
  	end

  	#Create a variable with the same data as @user and
  	#save it to the database. This should cause @user to be invalid
  	#because its email is already in the database.
  	describe "when email address is already taken" do
  		before do
  			user_with_same_email = @user.dup
  			user_with_same_email.email = @user.email.upcase
  			user_with_same_email.save
  		end

  		it { should_not be_valid }
  	end

  	#Makes sure that email addresses are saved entirely lower case
  	#First, create a temporary email address with mixed cases
  	#Then set @user's email to the temporary email and save to db
  	#Reload @user's email address and make sure it equals the 
  	#temporary email address entirely in lower case
  	describe "email address with mixed case" do
  		let(:mixed_case_email) { "Foo@ExAMPLe.CoM" }

  		it "Should be saved as all-lower case" do
  			@user.email = mixed_case_email
  			@user.save
  			expect(@user.reload.email).to eq mixed_case_email.downcase
  		end
  	end

  	#PASSWORD AUTHENTICATION

  	#Test to validate the presence of a password
  	describe "when password is not present" do
  		before do
  			@user = User.new(name: "Example User", email: "user@example.com",
  				password: " ", password_confirmation: " ")
  		end
  		it { should_not be_valid }
  	end

  	#Test to make sure password and password_confirmation do not mismatch
  	#SELF-ASSIGNED TASK: Can you manually set both 'password'
  	#and 'password_confirmation' then state that they should not
  	#be valid? Manually set @user.password = "match" and test
  	describe "when password doesn't match confirmation" do
  		before { @user.password_confirmation = "mismatch" }
  		it { should_not be_valid }
  	end

  	#User must have a method :authenticate
  	it { should respond_to(:authenticate) }

  	#Ensure that the password authentication procedure works properly
  	#1: Make sure a correct password is authenticated
  	#2: Make sure an incorrect password is registered as incorrect
  	describe "return value of authenticate method" do
  		before { @user.save }
  		let(:found_user) { User.find_by(email: @user.email) }

  		#authenticate function should return found_user, which
  		#should equal it (i.e. @user). If authenticate fails
  		#it returns false, making the 'should' statement false.
  		#This function ensures that a valid password is correctly
  		#authenticated
  		describe "with valid password" do
  			it { should eq found_user.authenticate(@user.password) }
  		end

  		#This function makes sure that an invalid password does not
  		#become authenticated by the app.
  		#Create a user that should be false because it is initialized
  		#to authenticate with an incorrect password.
  		#it #1 checks that @user does not equal the temporary variable
  		#it #2 checks that the temporary variable is false (in a sense
  		# this covers the same constraint as it #1)
  		describe "with invalid password" do
  			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

  			it { should_not eq user_for_invalid_password }
  			it { expect(user_for_invalid_password).to be_false }
  		end
  	end 
  	
  	#Make sure that the password is long enough (6 character minimum)
  	#Create a temp password and password_confirmation 5 characters long
  	#Make sure that they fail
  	describe "with a password that's too short" do
  		before { @user.password = @user.password_confirmation = "a" * 5 }
  		it { should be_invalid}
  	end
end