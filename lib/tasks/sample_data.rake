#Rake for generating sample users
namespace :db do
	#rake description
	desc "Fill database with sample data"
	#Ensures rake has access to local rails environment (i.e. allows it to use User.create!)
	task populate: :environment do
		#Call functions for creating sample users, microposts, and relationships
		make_users
		make_microposts
		make_relationships
	end
end

def make_users
	#Create one sample uuser with given criteria
	#Exclamation point after create makes it throw an exception for invalid information
	#rather than just returning false, making it easier to debug
	#THE FIRST USER IS AN ADMIN
	User.create!( 	name: "Example User",
					email: "example@railstutorial.org",
					password: "foobar",
					password_confirmation: "foobar",
					admin: true )

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

def make_microposts
	#For the first 6 users add 50 fake microposts
	users = User.all(limit: 6)
	#Like a for loop, 50 iterations
	50.times do
		#Set content to a fake sentence using Faker
		content = Faker::Lorem.sentence(5)
		#For each user (loop through all) create a micropost with content
		#created in content variable
		users.each { |user| user.microposts.create!(content: content) }
	end
end

def make_relationships
	#Create an array of all users
	users = User.all
	#Select the first user
	user = users.first
	#Create an array of users to follow user
	followed_users 	= users[2..50]
	#Create an array of users following user
	followers 		= users[3..40]
	#For each followed user, have user follow them
	followed_users.each { |followed| user.follow!(followed) }
	#For each follower, have them follow the user
	followers.each { |follower| follower.follow!(user) }
end
