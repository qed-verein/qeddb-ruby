class DatabasePolicy < Struct.new(:user, :database)
	include PunditImplications

	define_implications(
		{
			:by_admin => [:import, :export],
			:by_treasurer => [:import_banking_statement, :sepa_export]
		}
	)

	def initialize(user, object)
		if user.treasurer?
			grant :by_treasurer
		end
		if user.admin? || user.chairman?
			grant :by_admin
		end
	end
end
