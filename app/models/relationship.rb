class Relationship < ActiveRecord::Base
	#Relationships belong to both followers and followed users,
	#The follower_id and followed_id is immplied by rails, but because they do not have their
	#own models, we must specify the class name
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	#Validate follower and followed id only if they exist (i.e. relationship is invalid if
	#either follower_id or followed_id is nil or not existant)
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end
