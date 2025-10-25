class Api::V1::CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show ]

  def show
    render json: { mssg: "Customer not found" }, status: :not_found and return if @customer.nil?
    render json: @customer
  end

  private
    def set_customer
      @customer = Customer.where(id: params[:id]).last
    end

    def customer_params
      params.require(:customer).permit(:customer_name, :address, :orders_count)
    end
end
