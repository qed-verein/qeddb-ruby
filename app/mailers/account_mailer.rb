# frozen_string_literal: true

class AccountMailer < ApplicationMailer
  def reset_password_email(person)
    @person = person
    @url = edit_password_reset_url(@person.reset_password_token)
    mail(to: @person.email_address, subject: 'Passwort zurücksetzen')
  end

  def account_created_email
    @person = params[:person]
    @database_url = root_url
    @password_url = edit_password_reset_url(@person.reset_password_token)
    mail(to: @person.email_address, subject: 'Benutzerkonto wurde angelegt')
  end
end
