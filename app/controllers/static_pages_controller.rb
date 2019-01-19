class StaticPagesController < ApplicationController

 #Adding a feed instance variable to the home action.
  def home
    #binding.pry
    @user = current_user
    @categories_select = ["APPETIZER", "BREAKFAST", "LUNCH", "DINNER", "DESSERT", "BEVERAGE", "SPECIAL OF THE DAY"]
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

  def contact_us
    UserMailer.say_hello(params).deliver_now
    flash.now[:info] = "Message sent successfully."
    render :template => 'static_pages/home'
  end

  def index
    render :template => 'static_pages/home'
  end

  def help
  end

  def about
  end

  def contact
  end
end
