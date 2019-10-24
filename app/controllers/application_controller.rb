# frozen_string_literal: true

class ApplicationController < ActionController::API
  attr_reader :current_user

  private

  rescue_from ActiveRecord::RecordNotFound do |e|
    json_error(e.message, 404)
  end

  rescue_from do
    json_error('Internal server error', 500)
  end

  def json_response(body, status = 200)
    render json: body, status: status
  end

  def json_error(error, status)
    message = error.is_a?(Hash) ? error.values.flatten.first : error
    json_response({ error: message }, status)
  end

  def authorize
    command = RequestAuthorizer.call(request.headers)

    if command.success?
      @current_user = command.result
    else
      json_error('Unauthorized', 401)
    end
  end
end
