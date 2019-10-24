# frozen_string_literal: true

module Api
  module V1
    class TicketsController < ApplicationController
      before_action :set_event

      # GET events/:id/tickets
      def index
        @tickets = @event.available_tickets

        render json: @tickets
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_event
        @event = Event.find(params[:event_id])
      end
    end
  end
end
