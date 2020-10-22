class AddShippedDateToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :shipped_date, :datetime
  end
end
