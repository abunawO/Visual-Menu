class UsersController < ApplicationController
 before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers] #Requiring a logged-in user for the index action
 before_action :correct_user,   only: [:edit, :update]
 before_action :admin_user,     only: :destroy   #A before filter restricting the destroy action to admins.

  #@users = User.all
  def index
    @users = User.paginate(page: params[:page])
  end

  def search
    @user = User.find(params[:id] || params[:user_id]) || current_user
    if params[:search].blank?
      flash.now[:danger] = "Invalid search"
      @feed_items = []
    else
      if params[:category]
        @feed_items = @user.feed.where("content LIKE ?", "%#{params[:search].upcase.strip}%").where("category LIKE ?", "%#{ params[:category].upcase.strip}%").paginate(page: params[:page])
      else
        @feed_items = @user.feed.where("content LIKE ?", "%#{params[:search].upcase.strip}%").paginate(page: params[:page])
      end
    end
  end


  def new
    #binding.pry
    #render(text:"hello i am user");
    #@user = User.find(params[:id])
    @user = User.new
  end

  def show
    @user = User.find(params[:id] || params[:user_id]) || current_user
    @microposts = @user.microposts.paginate(page: params[:page])
    @categories = []
    @user.microposts.each do |micropost|
      if micropost.category.present?
        @categories.push(micropost) unless @categories.map(&:category).include?(micropost.category)
      end
    end
  end

  def category_search
    @user = User.find(params[:id] || params[:user_id]) || current_user
    unless params[:category][:title].present?
      flash.now[:danger] = "Invalid Category"
      @feed_items = []
    else
      @category = params[:category][:title]
      @feed_items = @user.feed.where("category LIKE ?", "%#{params[:category][:title]}%").paginate(page: params[:page])
      #redirect_to "/searched?_method=get&category_title%5Bmodel_field%5D=DINNER&user_id=2"
      #redirect_to root_url
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash.now[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash.now[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  #Adding a working destroy action.
  def destroy
    User.find(params[:id]).destroy
    flash.now[:success] = "User deleted"
    redirect_to users_url
  end

  #The following and followers actions.
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash.now[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
