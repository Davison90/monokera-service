class Api::V1::OrdersController < ApplicationController
  def customer_orders
    customer_orders = Order.where(customer_id: params[:customer_id])

    render json: { mssg: "No orders found for this customer" }, status: :not_found and return if customer_orders.empty?
    render json: customer_orders
  end

  def create
    order = Order.new(order_params)

    if order.save
      render json: order, status: :created
    else
      render json: order.errors.messages, status: :unprocessable_entity
    end
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

    def order_params
      params.require(:order).permit(:customer_id, :product_name, :quantity, :price)
    end
end
