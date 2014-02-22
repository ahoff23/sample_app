#Used  to create resource variables for tests in RSPEC
FactoryGirl.define do
	#Createa a user variable factory
	factory :user do
		name "Andrew Hoff"
		email "ahoff23@example.com"
		password "foobar"
		password_confirmation "foobar"
	end
end