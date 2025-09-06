class ApplicationController < ActionController::Base
  include Pundit

  breadcrumb Rails.configuration.database_title, :root_path

  protect_from_forgery with: :exception

  before_action :require_login
  before_action :set_paper_trail_whodunnit

  rescue_from Pundit::NotAuthorizedError, with: :access_denied_handler

  def access_denied_handler
    respond_to do |type|
      type.html do
        flash[:alert] = 'Access denied.'
        redirect_to root_path
      end
      type.all { render nothing: true, status: :forbidden }
    end
  end

  def user_for_paper_trail
    logged_in? ? current_user.full_name + " (ID: #{current_user.id})" : 'Anonym'
  end

  def not_authenticated
    redirect_to login_path, notice: 'Bitte einloggen.'
  end
end
