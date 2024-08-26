class FinanceReviewPolicy
	include PunditImplications
	define_implications(
		{
			by_auditor: [:view],
			by_treasurer: [:by_auditor, :export]
		}
	)

	def initialize(user, _)
		grant :by_treasurer if user.treasurer?
		grant :by_auditor if user.auditor?
	end
end
