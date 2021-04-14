class DatabasePolicy < Struct.new(:user, :database)
	include PunditImplications

	define_implications({
		:by_admin => [:import, :export]})

 	def initialize(user, object)
		if user.admin? || user.chairman?
			grant :by_admin
		end
	end
end
