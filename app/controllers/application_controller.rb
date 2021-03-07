require 'application_responder'

class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pundit

  before_action :ensure_minimum_role
  before_action :set_paper_trail_whodunnit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def ensure_minimum_role
    unless current_user&.meets_minimum_role?
      if User.invite_only?
        redirect_to '/closed'
      else
        flash[:alert] = 'An account is required'
        redirect_to signup_path
      end
    end
  end

  def user_not_authorized(e)
    message = e.reason ? t("pundit.errors.#{e.reason}") : 'You are not authorized to perform this action.'
    flash[:alert] = message
    redirect_to(request.referrer || root_path)
  end
end
