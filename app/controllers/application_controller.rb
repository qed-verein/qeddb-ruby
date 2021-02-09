class ApplicationController < ActionController::Base
	include Pundit

	breadcrumb Rails.configuration.database_title, :root_path

	protect_from_forgery with: :exception

	before_action :require_login
	before_action :set_paper_trail_whodunnit

	def user_for_paper_trail
		logged_in? ? current_user.full_name + " (ID: #{current_user.id})" : 'Anonym'
	end

	def not_authenticated
		redirect_to login_path, notice: "Bitte einloggen."
	end

end
