# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  # Ein Benutzer ruft das Loginformular auf
  def new
    redirect_to root_url, notice: t('.already') if logged_in?
    @person = Person.new
  end

  # Der Benutzer hat das ausgefüllte Loginformular abgeschickt
  def create
    redirect_to root_url, notice: t('.already') if logged_in?
    @person = login(params[:account_name], params[:password])
    if @person
      redirect_back_or_to root_path, notice: t('.success')
    else
      flash.now[:error] = t('.failed')
      render 'new'
    end
  end

  # Der Benutzer hat auf Logout geklickt
  def destroy
    logout
    redirect_to login_url, notice: t('.complete')
  end
end
