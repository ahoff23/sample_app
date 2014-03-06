class StaticPagesController < ApplicationController
  def home
    if signed_in?
    	#Create a micropost variable for the home view (root_path)
    	#Use build instead of new because microposts are a belongs_to subclass of User model
    	@micropost = current_user.microposts.build
      #Create a variable containing all feed items. Allow it to be paginated.
      #Feed is defined in the user model. It is just an array of microposts
      #Just as User is a collection of all users, feed is a collection of all microposts
      #TEST: Switch with microposts to see if it changes anything
      #It should not until you update feed to include users you are following
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
  
end
