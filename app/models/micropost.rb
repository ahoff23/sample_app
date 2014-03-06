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
end
