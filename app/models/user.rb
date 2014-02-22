class User < ActiveRecord::Base
	#Convert email to entirely lower case before saving to the database
	before_save { email.downcase! }

	#Validate that :name exists, has at most 50 characters
	#and is unique (CASE SENSITIVE)
	validates(:name, presence: true, length: { maximum: 50 })

	#Create a format for emails: (Word,-,.)+@+(a-z,digits,-,.)
	#+(.)+(a-z) (NOT CASE SENSITIVE)
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

	#Validate that :email exists, has a format according to VALID_EMAIL_REGEX
	#and that it is unique (NOT CASE SENSITIVE)
	validates(:email, presence: true, format: {with: VALID_EMAIL_REGEX},
		uniqueness: { case_sensitive: false })

	#Make sure all password tests pass
	#Covers many different requirements for passwords
	has_secure_password

	#Set a minimum length for a password
	validates :password, length: { minimum: 6 }
end
