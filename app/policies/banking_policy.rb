class BankingPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications(
    {
      by_treasurer: %i[import_banking_statement sepa_export]
    }
  )

  def initialize(user_context, _unused)
    super
    return unless active_treasurer?(@user, @mode)

    grant :by_treasurer
  end
end
