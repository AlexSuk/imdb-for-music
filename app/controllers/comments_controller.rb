class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :destroy]
  before_action :find_commentable
  before_action :correct_user, only: :destroy


  def new
    @comment = Comment.new(comment_params)
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id


    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: 'You Successfully Posted!' }
        format.json { render :show, status: :created, location: @commentable }
      else
        format.html { redirect_to :back, notice: "Your comment wasn't posted. Please try again."}
        format.json { render json: @commentable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = "Comment destroyed"
    redirect_to request.referrer || root_url
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :user_id)
  end

  def find_commentable
    @commentable = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
    @commentable = Post.find_by_id(params[:post_id]) if params[:post_id]
  end

  def correct_user
    @comment = current_user.comments.find_by_id(params[:id])
    redirect_to root_url if @comment.nil?
  end
end
