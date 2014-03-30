class User < ActiveRecord::Base
	#Contains microposts and destroys associated microposts if the user is destroyed
	has_many :microposts, dependent: :destroy

	#Each user has relationships with other users
	#However, a foreign key, follower_id, is required because that is how one tracks
	#users (i.e. there is no user_id in the relationships model)
	#Relationships are destroyed if user is destroyed
	#Can only search by followers
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy

	#Each user has many followed users through their relationships
	#Since "followeds" is awkward, change the name and specify the real model
	#with the source: :followed line
	has_many :followed_users, through: :relationships, source: :followed

	#Create a reverse relationshps table which reverses the relationships table using
	#followed_id as the foreign key instead of the follower_id
	#Use the class_name "Relationship" to inform rails that the class referred to is actually the relationships table
	has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

	#Each user has many followers through their relationships, but accessed through reverse relationships table
	has_many :followers, through: :reverse_relationships, source: :follower
	
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

	#Create an array of microposts (currently only the user's microposts)
	def feed
		#Return all microposts from the function 'from_users_followed_by'
		#in the micropost controller
		Micropost.from_users.followed_by(self)
	end

	#Function returning whehter or not the user is following the user
	#in the parameter
	def following?(other_user)
		#Search for this user in the relationships table by looking for
		#the other user's id in the followed_id column
		relationships.find_by(followed_id: other_user.id)
	end

	#Function which creates a new relationship where this user follows another user
	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	#Function for a user to unfollow the other_user
	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy
	end
	
	private

		#Create a token for this user. Called before creating the user
		#Set as private because it is only called within the user model
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
	#END PRIVATE BLOCK
end