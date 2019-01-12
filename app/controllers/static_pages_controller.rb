class StaticPagesController < ApplicationController

 #Adding a feed instance variable to the home action.
  def home
    #binding.pry
    @user = current_user
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

      @microposts = @user.microposts.paginate(page: params[:page])
      @categories = []
      @user.microposts.each do |micropost|
        if micropost.category.present?
          @categories.push(micropost) unless @categories.map(&:category).include?(micropost.category)
        end
      end
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
