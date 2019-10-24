# frozen_string_literal: true

module RequestSpecHelper
  def json_response
    JSON.parse(response.body)
  end

  def get_resource(resource)
    get "/api/v1/#{resource}"
  end

  def authenticate(credentials = {})
    post '/api/v1/authenticate', params: credentials
    @token = json_response['auth_token']
  end

  def put_with_token(resource, params, headers = {})
    put "/api/v1/#{resource}", params: params, headers: with_token(headers)
  end

  def post_with_token(resource, params, headers = {})
    post "/api/v1/#{resource}", params: params, headers: with_token(headers)
  end

  def with_token(headers)
    headers.merge('Authorization' => @token)
  end
end
