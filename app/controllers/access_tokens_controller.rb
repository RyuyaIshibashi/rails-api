class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    result = authenticator.access_token
    render json: serializer.new(result), status: :created
  end

  def serializer
    AccessTokenSerializer
  end
end
