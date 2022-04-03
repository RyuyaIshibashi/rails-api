class ApplicationController < ActionController::API
  include JsonapiErrorsHandler

  ErrorMapper.map_errors!(
    'ActiveRecord::RecordNotFound' =>
      'JsonapiErrorsHandler::Errors::NotFound'
  )
  rescue_from ::StandardError, with: lambda { |e| handle_error(e) }

  class AuthorizationError < StandardError; end
  
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error
  rescue_from AuthorizationError, with: :authorization_error

  private 
  
  def authentication_error
    error = error_hash("401", "/code", "Authentication code is invalid", "You must provide valid code in order to exchange it for token.")
    render json: { "errors": [ error ] }, status: 401
  end

  def authorization_error
    error = error_hash("403", "/headers/authorization", "Not authorized", "You have no right to access this resource.")
    render json: { "errors": [ error ] }, status: 403
  end

  def error_hash (status, source, title, detail)
    return {
      status: status,
      source: { pointer: source },
      title:  title,
      detail: detail
    }
  end
end
