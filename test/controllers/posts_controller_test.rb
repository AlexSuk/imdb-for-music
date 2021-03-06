require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @post = posts(:muse)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Post.count" do
      post posts_path(mbid: @post.mbid), params: { post: { body: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Post.count" do
      delete post_path(id: @post.id, mbid: @post.mbid)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong user" do
    log_in_as(users(:lana))
    post = posts(:muse)
    assert_no_difference 'Post.count' do
      delete post_path(id: post.id, mbid: post.mbid)
    end
    assert_redirected_to root_url
  end

end
