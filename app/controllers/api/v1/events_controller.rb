# frozen_string_literal: true

module Api
  module V1
    class EventsController < ApplicationController
      # GET /events
      def index
        @events = Event.all

        render json: @events
      end

      # GET /events/:id
      def show
        @event = Event.find(params[:id])

        render json: @event
      end
    end
  end
end
