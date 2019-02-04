class SessionsController < ApplicationController

  def new
  end

 def create
  # binding.pry
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      if user.activated?
        log_in user
        remember(user) #params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to '/'
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end


  #Only logging out if logged in.
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end


end
