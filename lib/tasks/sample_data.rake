#Rake for generating sample users
namespace :db do
	#rake description
	desc "Fill database with sample data"
	#Ensures rake has access to local rails environment (i.e. allows it to use User.create!)
	task populate: :environment do
		#Create one sample uuser with given criteria
		#Exclamation point after create makes it throw an exception for invalid information
		#rather than just returning false, making it easier to debug
		#THE FIRST USER IS AN ADMIN
		User.create!( 	name: "Example User",
						email: "example@railstutorial.org",
						password: "foobar",
						password_confirmation: "foobar",
						admin: true)
		#Create 99 other sample users using Faker gem
		99.times do |n|
			name = Faker::Name.name
			#Generate an email: example-n@railstutorial.org for all n from 1 to 100
			email = "example-#{n+1}@railstutorial.org"
			password="password"
			#Create a user with the newly generated name and email informaion
			User.create!(	name: name,
							email: email,
							password: password,
							password_confirmation: password)
		end
	end	
end