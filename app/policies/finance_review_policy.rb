class FinanceReviewPolicy
	include PunditImplications
	define_implications(
		{
			by_auditor: [:view, :export],
			by_treasurer: [:by_auditor]
		}
	)

	def initialize(user, _)
		grant :by_treasurer if user.treasurer?
		grant :by_auditor if user.auditor?
	end
end
