class SessionsController < ApplicationController
  def new
    user = current_user
    if user != nil
      redirect_to user
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
      redirect_to user
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end
end

def log_in(user)
  session[:user_id] = user.id
end

private

	def current_user
		User.find_by(id: session[:user_id])
	end
