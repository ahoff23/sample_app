class UsersController < ApplicationController
  #Only allow edit and update functions after running 'signed_in_user' function (private)
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy, :following, :followers]
  #Only allow edit and update functions after running 'correct_user' function (private)
  before_action :correct_user, only: [:edit, :update]
  #Only allow admins to issue a DELETE request (admin_user function can be found in private)
  before_action :admin_user,  only: :destroy
  #Only allow non-signed in users to create a new users
  before_action :signed_out_user, only: [:new, :create]
  #Do not allow admin to delete themselves
  before_action :admin_no_self_delete, only: [:destroy]

  #controller for the 'show' view
  #finds a user based on a given param ([:id]) and create a variable to trakc it
  def show
  	@user = User.find(params[:id])
    #Create a variable containing all microposts for the show view
    #Must create a microposts view folder and a _micropost.html.erb file for partial
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  #Creates a new user temporarily for the signup page
  #This user is stored to the database if it meets the proper criteria
  def new
  	@user = User.new
  end

  #Create a new user based on parameters passed from the signup page
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  #NOTE: When creating a user signup page, you must deploy with SSL production
  #in oder to ensure user security (See end of chapter 7 of RoR Tutorial)
  #Uncomment 'config.force_ssl = true' in config/environments/production.rb
  #and when pushing to Heroku type: git commit -a -m "Add SSL in production"
  #then: git push heroku. then: heroku run rake db:migrate. then: heroku open
  #this will cause the http:// to become https://
  #This process is different if you are not using Heroku. Heroku's website
  #has an explanation of how to perform SSL production without Heroku
  #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  def create
    #Create a new user whose parameters are defined using strong parameters defined below
    @user = User.new(user_params)
    #If save is successful...
    if @user.save
      #Sign the user in
      sign_in @user
      #Create and submit a flash hash which displays a welcome message to the user
      #on the redirected page
      flash[:success] = "Welcome to the Sample App!"
      #Redirect to user page
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    #Remove @user = User.find(params[:id]) because it was moved to correct_user (private)
  end

  #Update the user information
  def update 
    #Remove @user = User.find(params[:id]) because it was moved to correct_user (private)
    #Update attributes with user_params (strong parameter)
    if @user.update_attributes(user_params)
      #Flash success and redirect to user page
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      #Render edit (HTML, NOT FUNCTION) which renders errors, so those should be printed
      render 'edit'
    end
  end

  #Displays all users
  def index
    #Create a variable containing all users on the page in the param
    @users = User.paginate(page: params[:page])
  end

  #Delete a user
  def destroy
    #find the user in the database and delete the user
    User.find(params[:id]).destroy
    #Flash a success message
    flash[:success] = "User deleted."
    #Redirect to user index
    redirect_to users_url
  end

  #Function returning all users the user is following
  def following
    #Provide a title beause the render applies to both this and followers function
    @title = "Following"
    #Find the user in order to collect their followers
    @user = User.find(params[:id])
    #Paginate all users in the followed parameter of @user for display
    @users = @user.followed_users.paginate(page: params[:page])
    #Render the follower/followed display
    render 'show_follow'
  end

  #Function returning all users following the user
  def followers
    #Provide a title beause the render applies to both this and following function
    @title = "Followers"
    #Find the user in order to collect their followers
    @user = User.find(params[:id])
    #Paginate all users in the followed parameter of @user for display
    @users = @user.followers.paginate(page: params[:page])
    #Render the follower/followed display
    render 'show_follow'
  end

  private

  #Define parameters that can be passed to a newly created user
  def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  #Create @user (NEEDED FOR UPDATE FUNCTION) and redirect to homepage unless the
  #current user is the correct user
  def correct_user
    #params[:id] is a hash based on the current update or user page i.e. users/id
    @user = User.find(params[:id])
    #current_user? can be found in the Session helper
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    #If the user is not an admin, redirect to the homepage
    redirect_to(root_url) unless current_user.admin?
  end

  #If the user is signed in, redirect them (signed in users should not be able
  #to create a new user)
  def signed_out_user
    if signed_in?
      redirect_to(root_url)
    end
  end

  #Admins should not be able to delete themselves
  def admin_no_self_delete
    @user = User.find(params[:id])
    if current_user == @user
      flash.now[:error] = 'Cannot delete yourself!'
      redirect_to(root_url)
    end
  end
end