class UsersController < ApplicationController
  def new
    #render(text:"hello i am user");
    #@user = User.find(params[:id])
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!" #Adding a flash message to user signup.
      redirect_to @user #redirect to users page
    else
      render 'new'
    end
  end

  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
end
