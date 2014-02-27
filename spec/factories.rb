#Used  to create resource variables for tests in RSPEC
FactoryGirl.define do
	#Createa a user variable factory
	factory :user do
		#Variable n created and incremented with each new FactoryGirl,
		#Creating a unique name for each
		sequence(:name) 	{ |n| "Person #{n}" }
		sequence(:email) 	{ |n| "person_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"

		#Make user an admin with the command FactoryGirl.create(:admin)
		#instead of FactoryGirl.create(:user)
		factory :admin do
			admin true
		end
	end
end