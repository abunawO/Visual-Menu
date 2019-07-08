class MicropostsController < ApplicationController
    #Adding authorization to the Microposts controller actions
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

  def create
    @user = current_user
    if @user.menu_categories.present?
      @categories_select = @user.menu_categories.split(",")
    else
      @categories_select = ["BREAKFAST", "LUNCH", "DINNER", "DESSERTS", "APPETIZERS", "SIDES", "BEVERAGES", "SPECIALS" ]
    end
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Menu item created successfully!"
      redirect_to root_url
    else
      #Adding an (empty) @feed_items instance variable to the create action.
      _set_defaults

      render 'static_pages/home'
    end
  end

  def edit
    #binding.pry
    @user = current_user
    if @user.menu_categories.present?
      to_sub_categories = @user.menu_categories.split(",")
      standard_categories = @user.menu_categories.split(",")
    else
      to_sub_categories = ["BREAKFAST", "LUNCH", "DINNER", "DESSERTS", "APPETIZERS", "SIDES", "BEVERAGES", "SPECIALS" ]
      standard_categories = ["BREAKFAST", "LUNCH", "DINNER", "DESSERTS", "APPETIZERS", "SIDES", "BEVERAGES", "SPECIALS" ]
    end

    micropost_id = params['micropost_id'] || params['id']
    @micropost = Micropost.find(micropost_id)
    micropost_category = [@micropost.category]

    if @micropost.category.present?
      @categories = (to_sub_categories.replace(micropost_category) + micropost_category.replace(standard_categories)).uniq
    else
      @categories = standard_categories
    end

    @categories_select = @categories

    update_micropost(params) if !params['edit_clicked']
  end

  def update_micropost params
    @micropost.content  = params[:micropost][:content]
    @micropost.category = params[:micropost][:category]
    @micropost.picture  = params[:micropost][:picture]
    @micropost.price    = params[:micropost][:price]
    @micropost.description = params[:micropost][:description]

    if @micropost.save
      flash.now[:success] = "Menu item updated successfully!"
      redirect_to "/users/#{current_user.id}"
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
    @micropost.destroy
    flash[:success] = "Menu item deleted successfully"
    redirect_to request.referrer || root_url
  end

  private

    #Adding picture to the list of permitted attributes.
    def micropost_params
      params.require(:micropost).permit(:content, :category, :price, :description, :picture, :side)
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
