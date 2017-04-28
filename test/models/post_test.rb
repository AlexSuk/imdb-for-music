require 'test_helper'

class PostTest < ActiveSupport::TestCase

  def setup
    @user = users(:jose)
    @post = @user.posts.build(title: "Lorem", body: "Lorem ipsum", user_id: @user.id,
                              mbid: "ef0d903f-edb3-45d9-a9d7-bf534b4be696" )
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
