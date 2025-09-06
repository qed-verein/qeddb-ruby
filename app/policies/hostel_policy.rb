# frozen_string_literal: true

class HostelPolicy
  include PunditImplications

  define_implications({
                        by_member: %i[show index],
                        by_admin: %i[by_member new edit destroy export]
                      })

  alias update? edit?
  alias create? new?

  def initialize(user, _hostel)
    if user.admin? || user.chairman? || user.organizing_now?
      grant :by_admin
    elsif user.member?
      grant :by_member
    end
  end

  def permitted_attributes
    [:title, :homepage, :comment,
     { address_attributes: %i[id country city postal_code street_name house_number address_addition] }]
  end
end
