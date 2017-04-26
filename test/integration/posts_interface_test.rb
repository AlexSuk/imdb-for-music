require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:jose)
  end

  test "post interface" do
    log_in_as(@user)
    get root_path

    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { title: "", body: "" } }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    title = "Sample Title"
    body = "Sample post"
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { user_id: @user.id, title: title, body: body } }
    end
    assert_redirected_to post_url(Post.last)
    follow_redirect!
    assert_match body, response.body

=begin
    # Invalid comment submission
    # Valid comment submission
    @user2 = users(:lana)
    log_in_as(@user2)
    body = "Sample comment"
    assert_difference 'Comment.count', 1 do
      post post_comments_path(post_id: Post.last.id), params: { comment: { user_id: @user2.id, body: body } }
    end
    assert_redirected_to post_url(Post.last)
    follow_redirect!
    assert_match body, response.body
=end

    # Delete post
    #get user_path(@user2)
    assert_select 'a', text: 'delete', count: 1
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end

    # Visit different user (no delete)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0



    # Delete comment
    # Can't delete other users' comments
    # Comment on other user's post
  end
end
