require 'spec_helper'

describe RelationshipsController do

	#Create two users, one for following and one to be followed
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user) }

	#Sign user in (follower), without capybara because this will test Ajax
	before { sign_in user, no_capybara: true }

	describe "creating a relationship Ajax" do

		it "should increment the Relationship count" do
			#Expect posting create function of relationship controllower with the follower_id
			#of other user (user being followed) to increase the number of relationships by 1
			expect do
				xhr :post, :create, relationship: { followed_id: other_user.id }
			end.to change(Relationship, :count).by(1)
		end

		#Post a create action from the relationship controller and expect
		#a successful response
		it "should respond with success" do
			xhr :post, :create, relationship: { followed_id: other_user.id }
			expect(response).to be_success
		end
	end

	describe "destroying a relationship with Ajax" do

		#Create a felationship by having the user follow the other user
		before { user.follow!(other_user) }
		#Find the previously created relationship and store it to a variable
		let(:relationship) do
			user.relationships.find_by(followed_id: other_user.id)
		end

		#Delete the relationship and expect the Relationship count to decrease by 1
		it "should decrement the Relationship count" do
			expect do
				xhr :delete, :destroy, id: relationship.id
			end.to change(Relationship, :count).by(-1)
		end

		#Delete the relationship and expect success
		it "should respond with success" do
			xhr :delete, :destroy, id: relationship.id
			expect(response).to be_success
		end
	end
end