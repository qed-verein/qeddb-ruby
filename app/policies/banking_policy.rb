class BankingPolicy
	include PunditImplications

	define_implications(
		{
			:by_treasurer => [:import_banking_statement, :sepa_export]
		}
	)

	def initialize(user, unused)
		if user.treasurer?
			grant :by_treasurer
		end
	end
end

