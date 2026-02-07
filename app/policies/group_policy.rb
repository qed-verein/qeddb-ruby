class GroupPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications({
                        viewable: %i[show index],
                        editable: %i[viewable edit],
                        creatable: %i[new],
                        destroyable: %i[destroy],
                      })
  alias update? edit?
  alias create? new?

  # Wie AdminPolicy, aber einige der vordefinierten Gruppen sollen auch
  # von Admins nicht geändert beziehungsweise gelöscht werden dürfen
  def initialize(user_context, group)
    super
    return unless active_admin?(@user, @mode) || active_board_member?(@user, @mode)

    if group.is_a?(Group)
      grant :viewable
      grant :editable if group.editable?
      grant :destroyable if group.destroyable?
    elsif group == Group
      grant :viewable
      grant :creatable
    end
  end

  def permitted_attributes
    [:id, :title, :description,
     { member_affiliations_attributes: %i[id groupable_type groupable_id start end],
       group_affiliations_attributes: %i[id groupable_type groupable_id start end] }]
  end
end
