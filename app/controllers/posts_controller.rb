class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @posts = Post.all

    # after changing routes to look something like artist.:mbid/posts
    #@posts = Post.where(":mbid = ?", params[:artist_id])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'You Successfully Posted!' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post destroyed"
    redirect_to request.referrer || root_url
  end


  private

    def post_params
      params.require(:post).permit(:title, :user_id, :comment, :body, :mbid)
    end

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_url if @post.nil?
    end

end
