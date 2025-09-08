module PolicyHelper
  # ist user ein Admin und im priviliegierten Modus?
  def active_admin?(user, mode)
    user&.admin? && mode == 'privileged'
  end

  # ist user ein Chairman und im priviliegierten Modus?
  def active_chairman?(user, mode)
    user&.chairman? && mode == 'privileged'
  end

  # ist user ein Treasurer und im priviliegierten Modus?
  def active_treasurer?(user, mode)
    user&.treasurer? && mode == 'privileged'
  end
end
