class SepaMailer < ApplicationMailer
  before_action :set_variable

  def set_variable
    @person = params[:person]
    @execution_date = params[:execution_date]
    @amount = params[:amount]
    @reference_line = params[:reference_line]
    @sepa_mandate = @person.sepa_mandate
  end

  def sepa_direct_debit_announce_email
    mail(to: @person.email_address,	subject: 'Ankündigung SEPA-Lastschrift')
  end
end
