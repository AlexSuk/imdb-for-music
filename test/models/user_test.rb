require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    # Test author: Jose Ramirez
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
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
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  # validate email length
  test "email should not be to long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # validate email address format?
  test "email validation should accept valid addresses" do
    valid_addresses = valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # email validation should reject invalid addresses
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # email address uniqueness?
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    #duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # saving email addresses as lowercase?
  test "email addresses shoudl be saved as lowercase" do
    mixed_case_email = "Foo@ExAMple.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

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

  test "associated posts should be destroyed" do
    @user.save
    @user.posts.create!(title: "Lorem", body: "Lorem ipsum", mbid: "ef0d903f-edb3-45d9-a9d7-bf534b4be696")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end
end
