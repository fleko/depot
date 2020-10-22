require "application_system_test_case"

class CartsTest < ApplicationSystemTestCase
  setup do
    @cart = carts(:one)
  end

  test "visiting the index" do
    visit carts_url
    assert_selector "h1", text: "Carts"
  end

  # test "creating a Cart" do
  #   visit carts_url
  #   click_on "New Cart"

  #   click_on "Create Cart"

  #   assert_text "Cart was successfully created"
  #   click_on "Back"
  # end

  # test "updating a Cart" do
  #   visit carts_url
  #   click_on "Edit", match: :first

  #   click_on "Update Cart"

  #   assert_text "Cart was successfully updated"
  #   click_on "Back"
  # end

  test "updating a Cart" do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    assert_selector '#cart'

    assert_selector 'tr.line-item-highlight'

    accept_alert do
      click_on 'Empty cart', match: :first
    end

    assert_no_selector '#cart'
  end

  test "attempt to browse invalid Cart" do
    invalid_cart_id= "bogus_cart"

    visit cart_url(invalid_cart_id)

    assert_text "Invalid cart"

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["depot@example.com"],                      mail.to
    assert_equal 'Sam Ruby <depot@example.com>',            mail[:from].value
    assert_equal "Pragmatic Store Error", mail.subject
  end

  # test "destroying a Cart" do
  #   visit carts_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end

  #   assert_text "Cart was successfully destroyed"
  # end
end
