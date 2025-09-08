class AdminController < ApplicationController
    include PolicyHelper

    breadcrumb 'admin', :admin_path

    def enable_privileged_mode
        session[:mode] = 'privileged'
        flash[:notice] = t('actions.admin.enter_privileged_mode')
        redirect_to request.referer || root_path
    end

    def disable_privileged_mode
        session[:mode] = 'standard'
        flash[:notice] = t('actions.admin.exit_privileged_mode')
        redirect_to root_path
    end
end
