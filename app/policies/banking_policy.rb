class BankingPolicy
  include PunditImplications

  define_implications(
    {
      by_treasurer: %i[import_banking_statement sepa_export]
    }
  )

  def initialize(user, _unused)
    return unless user.treasurer?

    grant :by_treasurer
  end
end
