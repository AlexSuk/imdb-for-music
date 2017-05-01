class SessionsController < ApplicationController

  def new
    user = current_user
    if user != nil
      redirect_to user
    end
  end

  def create
    #render :text => request.env['rack.auth'].inspect
    #puts :text
    auth = request.env["omniauth.auth"]
    if auth
      user = User.where(uid: auth['uid'], provider: auth['provider']).first
      if user
        log_in user
        redirect_to user
      else
        puts "creating user"
        @user = User.new()
        @user.uid = auth['uid']
        @user.provider = auth['provider']
        @user.email = auth['uid'] + '@' + auth['provider'] + '.com'
        @user.name = auth.info.name
        @user.password = "foobar"
        respond_to do |format|
          if @user.save
            log_in @user
            puts "user save successful"
            format.html { redirect_to @user, notice: 'User was successfully created.' }
            format.json { render :show, status: :created, location: @user }
          else
            puts "user save unsuccessful"
            format.html { render :new }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      end
    else
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

  def destroy
      log_out
      redirect_to root_path
    end
  end


  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

private

	def current_user
		User.find_by(id: session[:user_id])
	end
