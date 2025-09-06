# frozen_string_literal: true

module PaperTrail
  class Version
    def self.policy_class
      VersionPolicy
    end
  end
end

class VersionPolicy
  include PunditImplications

  define_implications({
                        by_chairman: %i[index show],
                        by_admin: %i[by_chairman revert_all]
                      })

  def initialize(user, _object)
    if user.admin?
      grant :by_admin
    elsif user.chairman?
      grant :by_chairman
    end
  end
end
