module GenericPaymentsHelper
  def generic_payment_categories
    %i[banking insurance website sponsoring donation]
  end

  def new_generic_payment_link
    return nil unless policy(GenericPayment).create?

    icon_button t('actions.generic_payment.new'), 'add', new_generic_payment_path
  end

  def generic_payments_link
    return nil unless policy(GenericPayment).view?

    link_to GenericPayment.model_name.human(count: :other), generic_payments_path
  end

  def edit_generic_payment_link(generic_payment)
    return unless policy(generic_payment).edit?

    link_to t('actions.generic_payment.edit'), edit_generic_payment_path(generic_payment)
  end

  def delete_generic_payment_link(generic_payment)
    return unless policy(generic_payment).delete?

    link_to t('actions.generic_payment.delete'), generic_payment, method: :delete, data: {
      confirm: format(
        'Zahlung von „%<counterparty>s“ am %<money_transfer_date>s löschen?',
        counterparty: generic_payment.counterparty,
        money_transfer_date: generic_payment.money_transfer_date
      )
    }
  end
end
