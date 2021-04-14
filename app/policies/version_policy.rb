class PaperTrail::Version
  def self.policy_class
    VersionPolicy
  end
end

class VersionPolicy
	include PunditImplications

	define_implications({
		:by_chairman => [:index, :show],
		:by_admin    => [:by_chairman, :revert_all]
	})

	def initialize(user, object)
		if user.admin?
			grant :by_admin
		elsif user.chairman?
			grant :by_chairman
		end
	end
end

