class SessionsController < ApplicationController
 # Before actions to check paramters
  before_action :check_params, only: [:login]
  before_action :authenticate_user, only: [:logout]

  def unauth
  end

  # Find a user with the username and email pair, log in that user if they exist 
  def login
    # Find a user with params
    user = User.authenticate(@credentials[:username], @credentials[:password])
    if user
      # Save them in the session
      log_in user
      # Redirect to posts page
      redirect_to articles_path
  else
      respond_to do |format|              
    format.html {redirect_to :login, notice: 'User does not exist or incorrect password', status: 403}
        format.json {redirect_to :login, status: 403 }
      end   
  end
  end

  # Log out the user in the session and redirect to the unauth thing
  def logout
    log_out
    redirect_to login_path 
  end

  # Private controller methods
  private
  def check_params
    params.require(:credentials).permit(:email, :password)
    @credentials = params[:credentials]
  end
end
