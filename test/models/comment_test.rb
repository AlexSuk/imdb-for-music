require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @user = users(:archer)
    @post = @user.posts.last
    @comment = @post.comments.build(body: "Etc etc", user_id: @user.id )
  end

  # valid
  test "should be valid" do
    assert @comment.valid?
  end

  # user id present
  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  # body present
  test "body should be present" do
    @comment.body = "     "
    assert_not @comment.valid?
  end

  # comments cannot be made without a post?
end
