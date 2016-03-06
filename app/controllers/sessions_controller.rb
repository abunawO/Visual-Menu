class SessionsController < ApplicationController

  def new
  end

 def create
   #Finding and authenticating a user.
   # Log the user in and redirect to the user's show page.
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      #Handling the submission of the “remember me” checkbox.
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      redirect_to user
    else
      # Create an error message.
      #flash[:danger] = 'Invalid email/password combination' # Not quite right!
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