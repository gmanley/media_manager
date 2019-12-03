class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  protected

  def json_resource_errors
    { errors: resource.errors.full_messages.to_sentence }
  end
end
