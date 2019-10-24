# frozen_string_literal: true

class UserAuthenticator
  # put SimpleCommand before the class' ancestors chain
  prepend SimpleCommand

  # optional, initialize the command with some arguments
  def initialize(email, password)
    @email = email
    @password = password
  end

  # mandatory: define a #call method. its return value will be available
  #            through #result
  def call
    if user
      JsonWebToken.encode(user_id: user.id)
    else
      errors.add(:user_authentication, 'Invalid credentials')
      nil
    end
  end

  private

  def user
    @user ||= User.find_by_email(@email)&.authenticate(@password)
  end
end
