class StaticPagesController < ApplicationController

 #Adding a feed instance variable to the home action.
  def home
    @user = current_user
    @category = Category.new
    if logged_in?
      user_categories = Category.where(:user_id => @user.id)
      if user_categories.map(&:name).present?
        @categories_select = user_categories.map(&:name)
      else
        @categories_select = []
      end

      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])

      @microposts = @user.microposts.paginate(page: params[:page])
      @categories    = {}

      if @user.microposts
        user_categories.each do |category|
          @categories[category.name] = @user.microposts.where(:category_id => category.id)
        end
      else
        user_categories.map(&:name).each do |title|
          @categories[title] = []
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
