class MicropostsController < ApplicationController
    #Adding authorization to the Microposts controller actions
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Menu item created successfully!"
      redirect_to root_url
    else
      #Adding an (empty) @feed_items instance variable to the create action.
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def edit
    @categories = ["Appetizer", "Breakfast", "Lunch", "Dinner", "Desserts", "Beverages", "Special of the day"]
    micropost_id = params['micropost_id'] || params['id']
    @micropost = Micropost.find(micropost_id)
    update_micropost(params) if !params['edit_clicked']
  end

  def update_micropost params
    #binding.pry
    @micropost.content = params[:micropost][:content]
    @micropost.category = params[:micropost][:category]
    @micropost.picture = params[:micropost][:picture]
    @micropost.description = params[:micropost][:description]

    if @micropost.save
      flash[:success] = "Menu item updated successfully!"
      redirect_to root_url
    else
      flash[:info] = "An error occured while saving the menu item."
    end
  end

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
      params.require(:micropost).permit(:content, :category, :price, :description, :picture)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
