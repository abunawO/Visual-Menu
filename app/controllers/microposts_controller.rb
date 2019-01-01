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
    @micropost = Micropost.find(params['micropost_id'])
  end

  def update
    micropost = Micropost.find(params[:id])
    micropost.content = params[:micropost][:content] if params[:micropost][:content]
    micropost.picture = params[:micropost][:picture] if params[:micropost][:picture]
    if micropost.save
      flash[:success] = "Menu item updated successfully!"
      redirect_to root_url
    else
      flash[:info] = "An error occured while saving the menu item."
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Menu item deleted successfully"
    redirect_to request.referrer || root_url
  end

  private

    #Adding picture to the list of permitted attributes.
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

     def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

end
