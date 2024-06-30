class OutstandingPaymentsPolicy
	include PunditImplications
	define_implications({
		by_treasurer: [:view]
	})

	def initialize(user, unused)
		if user.treasurer?
			grant :by_treasurer
		end
	end
end

