class UsersController < ApplicationController
  #controller for the 'show' view
  #finds a user based on a given param ([:id]) and create a variable to trakc it
  def show
  	@user = User.find(params[:id])
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
      #Create and submit a flash hash which displays a welcome message to the user
      #on the redirected page
      flash[:success] = "Welcome to the Sample App!"
      #Redirect to user page
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  #Define parameters that can be passed to a newly created user
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


end
