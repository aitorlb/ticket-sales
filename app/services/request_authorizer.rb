# frozen_string_literal: true

class RequestAuthorizer
  # put SimpleCommand before the class' ancestors chain
  prepend SimpleCommand

  # optional, initialize the command with some arguments
  def initialize(headers = {})
    @headers = headers
  end

  # mandatory: define a #call method. its return value will be available
  #            through #result
  def call
    if user
      user
    else
      errors.add(:token, 'Invalid token')
      nil
    end
  end

  private

  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    @headers['Authorization'].split.last if @headers['Authorization'].present?
  end
end
