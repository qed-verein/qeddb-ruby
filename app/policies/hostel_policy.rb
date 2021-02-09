class HostelPolicy
	include PermissionImplications
	
	define_implications({
		:by_member => [:show, :index],
		:by_admin  => [:by_member, :new, :edit, :destroy, :export]
	})

	alias_method :update?, :edit?
	alias_method :create?, :new?
	
	def initialize(user, hostel)
		if user.admin? || user.chairman? || user.organizing_now?
			grant :by_admin
		elsif user.member?
			grant :by_member
		end
	end
	
	def permitted_attributes
		[:title, :homepage, :comment, 
			address_attributes: [:id, :country, :city, :postal_code, :street_name, :house_number, :address_addition]]
	end
end
