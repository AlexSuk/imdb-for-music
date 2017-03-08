require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@example",
                                         password: "pass",
                                         password_confirmation: "word" }}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation' # CSS id for error explanation, ie. the one that has # in custom.scss
    assert_select 'div.field_with_errors'# CSS class for field with error, that's just .field_with_errors in custom.scss
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count' do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }

    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
