# frozen_string_literal: true

module Api
  module V1
    class PurchasesController < ApplicationController
      before_action :authorize
      before_action :set_checkout_cart

      # PUT /events/1/purchases
      def update
        render json: @checkout_cart.tickets
      end

      # POST /events/1/purchases
      def create
        command = PurchaseMaker.call(
          checkout_cart: @checkout_cart,
          payment_token: params[:payment_token]
        )

        if command.success?
          @purchase = command.result

          render json: @purchase
        else
          json_error(command.errors, 422)
        end
      end

      private

      def ticket_locker
        @ticket_locker ||= TicketLocker.call(purchase_params)
      end

      def set_checkout_cart
        return json_error(ticket_locker.errors, 422) unless ticket_locker.success?

        @checkout_cart ||= CheckoutCart.new(ticket_locker.result, current_user)
      end

      # Only allow a trusted parameter "white list" through.
      def purchase_params
        params.permit(:event_id, :ticket_count).merge(user: current_user).to_h.symbolize_keys
      end
    end
  end
end
