class ChargeOrderJob < ApplicationJob
  queue_as :default

  def perform(order,pay_type_params)
    begin
      order.charge!(pay_type_params)
    rescue StandardError => e
      logger.error e.message
    end
  end
end
