class ApplicationController < ActionController::Base
  before_action :set_user_type
  before_action :authenticate_user!
  include Pundit

  # after_action :verify_authorized, except: :index, unless: :skip_pundit?
  # after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def set_user_type
    session[:user_type] = 'Artist' if controller_name == 'artists' && action_name == 'new'
    session[:user_type] = 'Label' if controller_name == 'labels' && action_name == 'new'
  end
end
