class StaticPagesController < ApplicationController

 #Adding a feed instance variable to the home action.
  def home
    @user = current_user
    if logged_in?
      if @user.menu_categories.present?
        @categories_select = @user.menu_categories.split(",")
      else
        @categories_select = ["BREAKFAST", "LUNCH", "DINNER", "DESSERTS", "APPETIZERS", "SIDES", "BEVERAGES", "SPECIALS" ]
      end

      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

      @microposts = @user.microposts.paginate(page: params[:page])
      @categories = []
      @options    = {}
      @user.microposts.each do |micropost|
        if micropost.category.present?
          unless @categories.map(&:category).include?(micropost.category)
            @categories.push(micropost)
            @options[micropost.category] = @user.microposts.where(:category => micropost.category)
          end
        end
      end
    end

  end

  def contact_us
    begin
      UserMailer.say_hello(params).deliver_later
      flash[:info] = "Message sent successfully."
      redirect_to root_url
    rescue Exception => e
      raise e
    end
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
