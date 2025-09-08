class HostelPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications({
                        by_member: %i[show index],
                        by_admin: %i[by_member new edit destroy export]
                      })

  alias update? edit?
  alias create? new?

  def initialize(user_context, _hostel)
    super
    if active_admin?(@user, @mode) || active_chairman?(@user, @mode) || @user.organizing_now?
      grant :by_admin
    elsif @user.member?
      grant :by_member
    end
  end

  def permitted_attributes
    [:title, :homepage, :comment,
     { address_attributes: %i[id country city postal_code street_name house_number address_addition] }]
  end
end
