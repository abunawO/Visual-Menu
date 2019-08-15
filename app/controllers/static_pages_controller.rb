class StaticPagesController < ApplicationController

  helper_method :cleanCategoryTitle

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

      @micropost  = Micropost.where(:user_id => current_user.id)
      @categories    = {}

      if @micropost
        user_categories.each do |category|
          @categories[category] = @micropost.where(:category_id => category.id)
        end
      else
        user_categories.map(&:name).each do |title|
          @categories[title] = []
        end
      end

      @categories = @categories.sort_by { |k,v| k.priority}
      @categories
    end

  end

  def update
    category = Category.find(params["category_id"])
    category.name = params["name"]
    category.priority = params["priority"]
    category.is_published = if params["is_published"] == "on" then true else false end
    if category.save!
      flash[:success] = "Category was successfully updated."
     redirect_to root_url
    else
      flash[:error] = "AN error accurred while updating the category."
    end
  end

  #can be used in view
  def cleanCategoryTitle string
    string.strip
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
