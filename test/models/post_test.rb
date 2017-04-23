require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @user = users(:jose)
    @post = @user.posts.build(body: "Lorem ipsum", user_id: @user.id)
    #@post = Posts.new(body: "Lorem ipsum", user_id: @user.id)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "body should be present" do
    @post.body = "   "
    assert_not @post.valid?
  end

  # do we want to limit the length of posts?

end
