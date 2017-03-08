require 'test_helper'

class ReleaseGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @release_group = release_groups(:one)
  end

=begin

  test "should get index" do
    get release_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_release_group_url
    assert_response :success
  end

  test "should create release_group" do
    assert_difference('ReleaseGroup.count') do
      post release_groups_url, params: { release_group: { image_url: @release_group.image_url, name: @release_group.name, record_label: @release_group.record_label } }
    end

    assert_redirected_to release_group_url(ReleaseGroup.last)
  end

  test "should show release_group" do
    get release_group_url(@release_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_release_group_url(@release_group)
    assert_response :success
  end

  test "should update release_group" do
    patch release_group_url(@release_group), params: { release_group: { image_url: @release_group.image_url, name: @release_group.name, record_label: @release_group.record_label } }
    assert_redirected_to release_group_url(@release_group)
  end

  test "should destroy release_group" do
    assert_difference('ReleaseGroup.count', -1) do
      delete release_group_url(@release_group)
    end

    assert_redirected_to release_groups_url
  end
=end
end
