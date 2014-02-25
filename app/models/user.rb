class User < ActiveRecord::Base
	#Convert email to entirely lower case before saving to the database
	#email.downcase! is equivalent to self.email=self.downcase
	before_save { email.downcase! }
	#Before creating a User, run the function create_remember_token
	before_create :create_remember_token

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

	#Generate a base 64 16 digit token
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end
	
	private

		#Create a token for this user. Called before creating the user
		#Set as private because it is only called within the user model
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
	#END PRIVATE BLOCK
end