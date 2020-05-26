require 'application_responder'

class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pundit

  before_action :set_paper_trail_whodunnit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(e)
    message = e.reason ? t("pundit.errors.#{e.reason}") : 'You are not authorized to perform this action.'
    flash[:alert] = message
    redirect_to(request.referrer || root_path)
  end
end
