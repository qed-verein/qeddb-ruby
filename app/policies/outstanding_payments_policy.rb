class OutstandingPaymentsPolicy
	include PunditImplications
	define_implications({
		by_treasurer: [:view, :export],
		by_auditor: [:view]
	})

	def initialize(user, unused)
		if user.treasurer?
			grant :by_treasurer
		end
		if user.auditor?
			grant :by_auditor
		end
	end
end

