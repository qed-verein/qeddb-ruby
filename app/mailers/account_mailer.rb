class AccountMailer < ApplicationMailer
  def reset_password_email(person)
    @person = person
    @url = edit_password_reset_url(@person.reset_password_token)
    mail(to: @person.email_address, subject: t('account_mailer.reset_password_email.subject'))
  end

  def account_created_email
    @person = params[:person]
    @database_url = root_url
    @password_url = edit_password_reset_url(@person.reset_password_token)
    mail(to: @person.email_address, subject: t('account_mailer.account_created_email.subject'))
  end
end
