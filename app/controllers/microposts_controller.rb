class MicropostsController < ApplicationController
    #Adding authorization to the Microposts controller actions
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

  def create
    @user = current_user

    user_categories = Category.where(:user_id => @user.id)

    if user_categories.map(&:name).present?
      @categories_select = user_categories.map(&:name)
    else
      @categories_select = []
    end

    @micropost = current_user.microposts.build(micropost_params)
    @micropost[:category_id] = params["category_id"]

    if @micropost.save
      flash[:success] = "Menu item created successfully!"
      redirect_to root_url
    else
      #Adding an (empty) @feed_items instance variable to the create action.
      _set_defaults

      render 'static_pages/home'
    end
  end

  def new
    @micropost = Micropost.new
    @selected_category = params[:category]
    @category_id = params[:category_id]
  end

  def edit
    @user = current_user

    user_categories = Category.where(:user_id => @user.id)

    if user_categories.map(&:name).present?
      @categories_select = user_categories.map(&:name)
    else
      @categories_select = []
    end

    micropost_id = params['micropost_id'] || params['id']
    @micropost = Micropost.find(micropost_id)

    @category = Category.find(params['category_id'])
    @category_id = @category.id
    @category_name = @category.name

    #@selected_category = params[:category]
    #@category_id = Category.where("name LIKE ?", "%#{@selected_category}%").first.id

    if !params['edit_clicked']
      update_micropost(params)
    end
  end

  def update_micropost params
    @micropost.content  = params[:micropost][:content]
    #@micropost.category = params[:micropost][:category]
    @micropost.picture  = params[:micropost][:picture]
    @micropost.price    = params[:micropost][:price]
    @micropost.description = params[:micropost][:description]

    if @micropost.save
      flash[:success] = "Menu item updated successfully."
      redirect_to root_url
    else
      flash[:info] = "An error occured while saving the menu item."
    end
  end

  # def modal
  #   @micropost = Micropost.find(params['micropost_id'])
  # end
  def show
    @micropost = Micropost.find(params['micropost_id'])
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "Menu item deleted successfully."
      redirect_to root_url
    else
      flash[:info] = "An error occured while deleting the menu item."
    end
  end

  private

    #Adding picture to the list of permitted attributes.
    def micropost_params
      params.require(:micropost).permit(:content, :category, :price, :description, :picture, :category_id)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def _set_defaults
      @feed_items = []
      @categories  = []
    end

end
