class GenericPaymentPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications(
    {
      by_auditor: %i[view export],
      by_treasurer: %i[by_auditor edit delete create]
    }
  )

  def initialize(user_context, _)
    super
    grant :by_treasurer if active_treasurer?(@user, @mode)
    grant :by_auditor if active_auditor?(@user, @mode)
  end

  def permitted_attributes
    if edit?
      %i[counterparty category money_transfer_date money_amount comment]
    else
      []
    end
  end
end
