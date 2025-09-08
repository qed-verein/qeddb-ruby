# UserContext um den privilegierten Modus an die Pundit policies durchzureichen
class UserContext
  attr_reader :user, :mode

  def initialize(user, mode)
    @user = user
    @mode = mode == 'privileged' ? 'privileged' : 'standard'
  end
end

class ApplicationController < ActionController::Base
  include Pundit

  breadcrumb Rails.configuration.database_title, :root_path

  protect_from_forgery with: :exception

  before_action :require_login
  before_action :set_paper_trail_whodunnit

  rescue_from Pundit::NotAuthorizedError, with: :access_denied_handler
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_handler

  def access_denied_handler
    respond_to do |type|
      type.html do
        flash[:alert] = t('sessions.access_denied')
        redirect_to root_path
      end
      type.all { render nothing: true, status: :forbidden }
    end
  end

  def pundit_user
    UserContext.new(current_user, session[:mode])
  end

  def record_not_found_handler
    respond_to do |type|
      type.html do
        flash[:alert] = 'Record not found.'
        redirect_to root_path
      end
      type.all { render nothing: true, status: :forbidden }
    end
    true
  end

  def user_for_paper_trail
    logged_in? ? current_user.full_name + " (ID: #{current_user.id})" : 'Anonym'
  end

  def not_authenticated
    redirect_to login_path, notice: t('sessions.login_required')
  end
end
