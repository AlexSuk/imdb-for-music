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

    # Delete post
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit different user (no delete)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
