require 'spec_helper'

describe Micropost do
  	
  	#Create a user for later tests
	let(:user) { FactoryGirl.create(:user) }
	#Create a micropost
	before { @micropost = user.microposts.build(content: "lorem ipsum") }

	#The subject of the tests is the micropost
	subject { @micropost }

  	#********************************************************
  	#Basic tests
  	#********************************************************
	#Each micropost should have content and a user id
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	#Each micropost should have an associated user
	it { should respond_to(:user) }
	#The associated user should equal the user which initialized the micropost
	its(:user) { should eq user }
	#The micropost should be valid

	#A micropost with no user_id should not be valid
	describe "when user ID does not exist" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	#Blank content should not be valid
	describe "with blank content" do
		#Set the microposts content to a blank space
		before { @micropost.content = " " }
		#Ensure that micropost is not valid
		it { should_not be_valid }
	end

	#Posts longer than 140 characters should not be valid
	describe "with content that is too long" do
		#Set the microposts content to 141 characters
		before { @micropost.content = "a" * 141 }
		#Ensure that the micropost is not valid
		it { should_not be_valid }
	end
end
