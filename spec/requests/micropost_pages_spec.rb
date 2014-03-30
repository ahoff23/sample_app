require 'spec_helper'

describe "Micropost pages" do

	#The subject is the page currently visited
	subject { page }

	#Create a user
	let(:user) { FactoryGirl.create(:user) }
	#Sign the user in
	before { sign_in user }

	describe "micropost creation" do
		#Visit the homepage
		before { visit root_path }

		describe "with invalid information" do

			it "should not create a micropost" do
				#Click the "post button" and make sure the number of microposts does not change
				expect { click_button "Post" }.not_to change(Micropost, :count)
			end

			describe "error messages" do
				#Click the "Post" button
				before { click_button "Post" }
				#'error' should be displayed
				it { should have_content('error') }
			end
		end

		describe "with valid information" do
			#Fill 'micropost_content' with content
			before{ fill_in 'micropost_content', with: "Loerm Ipsum" }

			it "should create a micropost" do
				#Click the post button and make sure the number of microposts increases by 1
				expect { click_button "Post" }.to change(Micropost, :count).by(1)
			end
		end
	end

	#Delete the micropost
	describe "micropost destruction" do
		#Create a micropost for the user
		before { FactoryGirl.create(:micropost, user: user) }

		describe "as correct user" do
			#Visit the homepage
			before { visit root_path }

			it "should delete a micropost" do
				#Delete the micropost by clciking the delete link
				expect{ click_link "delete" }.to change(Micropost, :count).by(-1)
			end
		end

		#Make sure a user does not see delete buttons for microposts of different users
		describe "link for different users microposts" do
			#Create a different user to create a micropost for
			let(:diffuser) { FactoryGirl.create(:user) }
			before do
				#Create a micropost for the different user
				FactoryGirl.create(:micropost, user: diffuser)
				#Sign the original user in
				sign_in user
				#Go to the different user's show page
				visit users_path(diffuser)
			end
			#Make sure that a delete button does not appear on the page
			it { should_not have_link("delete") }
			#Make sure the redirect went to the correct user's show page
			it { should have_content(diffuser.name) }
		end
	end
end