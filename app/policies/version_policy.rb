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
                        by_board_member: %i[index show],
                        by_admin: %i[by_board_member revert_all]
                      })

  def initialize(user_context, _object)
    super
    if active_admin?(@user, @mode)
      grant :by_admin
    elsif active_board_member?(@user, @mode)
      grant :by_board_member
    end
  end
end
