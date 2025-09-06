class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  # Der Benutzer möchte ein neues Passwort anfordern und muss hierzu seinen Benutzernamen angeben
  def new; end

  # Benutzer hat seinen Accountnamen angegeben und möchte ein neues Passwort anfordern
  def create
    person = Person.find_by_account_name(params[:account_name])
    person&.deliver_reset_password_instructions!
    redirect_to login_path, notice: t('.success')
  end

  # Der Benutzer bekommt die Möglichkeit ein neues Passwort anzugeben
  def edit
    @token = params[:id]
    @person = Person.load_from_reset_password_token(params[:id])
    invalid_password_token if @person.blank?
  end

  # Der Benutzer hat neue Passwörter abgeschickt
  def update
    @token = params[:id]
    @person = Person.load_from_reset_password_token(params[:id])

    if @person.blank?
      invalid_password_token
    else
      @person.password_confirmation = params[:person][:password_confirmation]
      if @person.change_password(params[:person][:password])
        redirect_to root_path, notice: t('.success')
      else
        render :edit
      end
    end
  end

  def invalid_password_token
    redirect_to new_password_reset_url, notice: 'Der Link zum Neusetzen des Benutzerpasswortes ist ungültig oder abgelaufen. ' \
                                                 'Bitte beginne den Vorgang von vorne.'
  end
end
