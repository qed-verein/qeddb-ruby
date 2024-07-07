class OutstandingPaymentsPolicy
	include PunditImplications
	define_implications(
		{
			by_treasurer: [:view, :export],
			by_auditor: [:view]
		}
	)

	def initialize(user, _)
		grant :by_treasurer if user.treasurer?
		grant :by_auditor if user.auditor?
	end
end
