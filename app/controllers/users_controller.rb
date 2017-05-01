class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    p = params
    @user = User.find(params[:id])
    @loggedUser = User.find_by(id: session[:user_id])
    if @loggedUser.nil?
      redirect_to root_url
    elsif @user.id != @loggedUser.id
      redirect_to 'users/#{@loggedUser.id}'
    end
    @favorites = Favorite.where("favorites.user_id = ?", "#{@user.id}")
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  # TODO: how do users edit their accounts?
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

=begin
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
=end

  def add_favorite
    fav = Favorite.new
    fav.user_id = params[:user_id]
    fav.link = params[:link]
    fav.m_category = params[:m_category]
    fav.save!
  end

  def remove_favorite
    Favorite.where("user_id = ? AND link = ?", "#{params[:user_id]}", "#{params[:link]}").destroy_all
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
