module PaperTrail
  class Version
    def self.policy_class
      VersionPolicy
    end
  end
end

class VersionPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications({
                        by_chairman: %i[index show],
                        by_admin: %i[by_chairman revert_all]
                      })

  def initialize(user_context, _object)
    super
    if active_admin?(@user, @mode)
      grant :by_admin
    elsif active_chairman?(@user, @mode)
      grant :by_chairman
    end
  end
end
