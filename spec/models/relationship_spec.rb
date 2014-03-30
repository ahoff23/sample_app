require 'spec_helper'

describe Relationship do
  #Create a follower user and a followed user
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  #Create a relationship between the two users
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  #Set the subject to relationship
  subject { relationship }
  
  #Relationship should be valid (basic test)
  it { should be_valid }

  describe "follower methods" do
  	#The relationship model should respond to follower and followed users
  	it { should respond_to(:follower) }
  	it { should respond_to(:followed) }
  	#The relationship's follower and followed should be equal to the 
  	#follower and followed created earlier because it was created with them as parameters
  	its(:follower) { should eq follower }
  	its(:followed) { should eq followed }
  end

  describe "when followed id is not present" do
  	#Set the relationship's followed id to nil
  	before { relationship.followed_id = nil }
  	#The relationship should not be valid
  	it { should_not be_valid }
  end

  describe "when follower id is not present" do
  	#Set the relationship's follower id to nil
  	before { relationship.follower_id = nil }
  	#The relationship should not be valid
  	it { should_not be_valid }
  end

end
