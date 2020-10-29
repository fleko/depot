require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "Login" do
    click_on "Logout", match: :first
    assert_text "Logged out"

    visit users_url

    assert_selector "h2", text: "Please Log In"

    fill_in "Name", with: @user.name
    fill_in "Password", with: 'secret'

    click_on "Login"

    assert_selector "h1", text: "Welcome"
  end


  test "visiting the index" do
    visit users_url

    assert_selector "h1", text: "Users"
  end

  test "creating a User" do
    visit users_url
    click_on "New User"

    user_name = 'Mike'

    fill_in "Name", with: user_name
    fill_in "Password", with: 'secret'
    fill_in "Confirm", with: 'secret'
    click_on "Create User"

    assert_text "User #{user_name} was successfully created"
  end

  test "updating a User" do
    visit users_url
    click_on "Edit", match: :first

    fill_in "Name", with: @user.name
    fill_in "Current Password", with: 'secret'
    fill_in "Password", match: :prefer_exact, with: 'secret'
    fill_in "Confirm", with: 'secret'
    click_on "Update User"

    assert_text "User #{@user.name} was successfully updated"
  end

  test "destroying a User" do
    visit users_url
    within all('.delete').last do
      page.accept_confirm do
        click_on "Destroy", match: :first
      end
    end

    assert_text "User was successfully destroyed"
  end
end
