class FinanceReviewPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications(
    {
      by_auditor: %i[view export],
      by_treasurer: [:by_auditor]
    }
  )

  def initialize(user_context, _)
    super
    grant :by_treasurer if active_treasurer?(@user, @mode)
    grant :by_auditor if active_auditor?(@user, @mode)
  end
end
