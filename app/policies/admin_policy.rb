# Das allgemiene Berechtigungskonzept für verschiedene Adminbereichte
# Wird zum Konfigurieren von Gruppen, Emailverteiler und Versionsständen hergenommen

class AdminPolicy
	include PermissionImplications
	
	define_implications({
		:viewable     => [:show, :index],
		:editable     => [:viewable, :edit, :new, :edit, :destroy]})
	alias_method :update?, :edit?
	alias_method :create?, :new?

	def initialize(user, object)
		if user.admin? || user.chairman?
			grant :editable
		end
	end
end
