class Micropost < ActiveRecord::Base
	#Sub-array for user model
	belongs_to :user
	#Set default order to created_at in descending order (earliest first)
	#DESC is SQL for descending
	default_scope -> { order('created_at DESC') }
	#Must have a non-nil user id
	validates :user_id, presence: true
	#Must have non-nil (or non-blank) content with length less than or equal to 140 characters
	validates :content, presence: true, length: { maximum: 140 }

	#Returns microposts from the user being followed by the given user
	def self.from_users_followed_by(user)
		#Create a variable storing the ids of followed users
		followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
	end
end
