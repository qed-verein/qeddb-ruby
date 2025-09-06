class GroupPolicy < AdminPolicy
  # Wie AdminPolicy, aber einige der vordefinierten Gruppen sollen auch
  # von Admins nicht geändert beziehungsweise gelöscht werden dürfen
  def initialize(user, group)
    super
    return unless user.admin? || user.chairman?

    if group.is_a?(Group)
      grant :viewable
      grant :edit if group.editable?
      grant :destroy if group.destroyable?
    elsif group == Group
      grant :editable
    end
  end

  def permitted_attributes
    [:id, :title, :description,
     { member_affiliations_attributes: %i[id groupable_type groupable_id start end],
       group_affiliations_attributes: %i[id groupable_type groupable_id start end] }]
  end
end
