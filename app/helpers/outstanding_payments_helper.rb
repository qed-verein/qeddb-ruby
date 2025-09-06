module OutstandingPaymentsHelper
  def outstanding_payments_link
    return unless policy(:outstanding_payments).view?

    link_to t('actions.outstanding_payments.view'), outstanding_payments_path
  end
end
