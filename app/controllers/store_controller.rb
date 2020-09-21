class StoreController < ApplicationController
  include CurrentCart

  before_action :set_cart

  def index
    @products = Product.order(:title)

    session[:counter] = session[:counter].nil? ? 1 : session[:counter] + 1

    @session_counter = session[:counter]
  end
end
