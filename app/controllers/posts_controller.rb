class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @posts = Post.where("mbid = ?", params[:mbid])
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end


  def create
    @post = current_user.posts.create(post_params)
    respond_to do |format|
      if @post.save
        @post.url = post_path(id: @post.id)
        @post.save
        format.html { redirect_to post_path(id: @post.id), notice: 'You Successfully Posted!' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO: need edit method
  def edit
    @post = current_user.posts.find(params[:id])
  end

  def update
    @post = current_user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to posts_path(id: @post.id), notice: "Your post was successfully edited"
    else
      render edit_post_path, notice: 'Your edit did not got through'
    end

  end

  def destroy
    @post.destroy
    flash[:success] = "Post destroyed"
    redirect_to user_url(current_user)
  end


  private

    def post_params
      params.require(:post).permit(:id, :title, :user_id, :comment, :body, :mbid)
    end

    def correct_user
      @post = current_user.posts.find_by_id(params[:id])
      redirect_to root_url if @post.nil?
    end

end
