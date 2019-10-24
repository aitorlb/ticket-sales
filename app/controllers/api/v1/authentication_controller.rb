# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApplicationController
      # POST /authenticate
      def authenticate
        command = UserAuthenticator.call(params[:email], params[:password])

        if command.success?
          render json: { auth_token: command.result }
        else
          json_error(command.errors, 401)
        end
      end
    end
  end
end
