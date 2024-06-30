class OutstandingPaymentsPolicy
	include PunditImplications
	define_implications({
		by_treasurer: [:view, :export]
	})

	def initialize(user, unused)
		if user.treasurer?
			grant :by_treasurer
		end
	end
end

