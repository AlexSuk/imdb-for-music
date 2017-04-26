require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  # should redirect create when not logged in
  # should redirect destroy when not logged in
  # should redirect destroy for wrong user
  def setup
    @post = posts(:muse)
    @comment = comments(:muse_one) # comment on a post
    @comment2 = comments(:muse_2) # comment on a comment
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Comment.count' do
      post post_comments_path(post_id: @post.id), params: { comment: {body: "Again and again" } }
    end
    assert_redirected_to login_url

    assert_no_difference 'Comment.count' do
      post comment_comments_path(comment_id: @comment.id), params: { comment: {body: "And again and again",} }
    end
    assert_redirected_to login_url

  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete post_comment_path(post_id: @post.id, id: @comment.id)
    end
    assert_redirected_to login_url

    assert_no_difference 'Comment.count' do
      delete comment_comment_path(comment_id: @comment2.id)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when wrong user" do
    log_in_as(users(:malory))
    assert_no_difference 'Comment.count' do
      delete post_comment_path(post_id: @post.id, id: @comment.id)
    end
    assert_redirected_to root_url #TODO: do we really want to redirect to root_url?

    assert_no_difference 'Comment.count' do
      delete comment_comment_path(comment_id: @comment.id, id: @comment2.id)
    end
    assert_redirected_to root_url
  end
end
