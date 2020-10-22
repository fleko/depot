require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  # test "visiting the index" do
  #   visit orders_url
  #   assert_selector "h1", text: "Orders"
  # end

  # test "creating a Order" do
  #   visit orders_url
  #   click_on "New Order"

  #   fill_in "Address", with: @order.address
  #   fill_in "Email", with: @order.email
  #   fill_in "Name", with: @order.name
  #   fill_in "Pay type", with: @order.pay_type
  #   click_on "Create Order"

  #   assert_text "Order was successfully created"
  #   click_on "Back"
  # end

  test "updating a Order" do
    visit orders_url
    click_on "Edit", match: :first

    shipped_date = DateTime.current.strftime("%d%m%Y\t%H%M")

    fill_in "Shipped date", with: shipped_date

    perform_enqueued_jobs do
      click_on "Update Order"
    end

    assert_text "Order was successfully updated"

    assert_equal shipped_date, Order.first.shipped_date.strftime("%d%m%Y\t%H%M")

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["mike@example.com"],                 mail.to
    assert_equal 'Sam Ruby <depot@example.com>',       mail[:from].value
    assert_equal "Pragmatic Store Order Shipped", mail.subject
  end

  test "destroying a Order" do
    visit orders_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order was successfully destroyed"
  end

  test "check routing number" do
    LineItem.delete_all
    Order.delete_all

    check_payment_type_selector('Check', '#order_routing_number')
  end

  # FIXME: breaks after task I, which is not compatible with previous "Play Time" refactor
  # test "check credit card number" do
  #   check_payment_type_selector('Credit card', '#order_credit_card_number')
  # end

  # test "check purchase order number" do
  #   check_payment_type_selector('Purchase order', '#order_po_number')
  # end

  test "error in Pago send correct email" do
    visit store_index_url

    click_on 'Add to Cart', match: :first

    click_on 'Checkout'

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main Street'
    fill_in 'order_email', with: 'dave@example.com'

    select 'Check', from: 'order[pay_type]'

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    mock = Minitest::Mock.new
    mock.expect :succeeded?, false
    mock.expect :error, "Pago Error"


    perform_enqueued_jobs do
      Pago.stub :make_payment, mock do
        click_button "Place Order"
      end
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"],                      mail.to
    assert_equal 'Sam Ruby <depot@example.com>',            mail[:from].value
    assert_equal "Pragmatic Store Order Processing Failed", mail.subject
  end

  private
    def check_payment_type_selector(payment_type, payment_type_selector)
      visit store_index_url

      click_on 'Add to Cart', match: :first

      click_on 'Checkout'

      fill_in 'order_name', with: 'Dave Thomas'
      fill_in 'order_address', with: '123 Main Street'
      fill_in 'order_email', with: 'dave@example.com'

      assert_no_selector payment_type_selector

      select payment_type, from: 'order[pay_type]'

      assert_selector payment_type_selector

      fill_in "Routing #", with: "123456"
      fill_in "Account #", with: "987654"

      perform_enqueued_jobs do
        click_button "Place Order"
      end

      orders = Order.all
      assert_equal 1, orders.size

      order = orders.first

      assert_equal "Dave Thomas",      order.name
      assert_equal "123 Main Street",  order.address
      assert_equal "dave@example.com", order.email
      assert_equal "Check",            order.pay_type
      assert_equal 1, order.line_items.size

      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dave@example.com"],                 mail.to
      assert_equal 'Sam Ruby <depot@example.com>',       mail[:from].value
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
    end
end
