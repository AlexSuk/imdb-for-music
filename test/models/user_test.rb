require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    # Test author: Jose Ramirez
    @user = User.new(name: "Example", password: "foobar",
                     password_confirmation: "foobar")
  end

  test "should be valid" do
    # Test author: Jose Ramirez
    assert @user.valid?
  end

  #validate name presence
  test "name should be present" do
    # Test author: Jose Ramirez
    @user.name = "      "
    assert_not @user.valid?
  end

  # validate name length
  test "name is no more than 50 characters long" do
    # Test author: Jose Ramirez
    @user.name = "A" * 51
    assert_not @user.valid?
  end

  # email address presence?
  # validate email address format?
  # email address uniqueness?
  # saving email addresses as lowercase?

  # password present?
  test "password should be nonblank" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # password minimum length?
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end


end
