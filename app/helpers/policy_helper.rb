module PolicyHelper
  # ist user ein Admin und im privilegierten Modus?
  def active_admin?(user, mode)
    user&.admin? && mode == 'privileged'
  end

  # ist user ein Chairman und im privilegierten Modus?
  def active_chairman?(user, mode)
    user&.chairman? && mode == 'privileged'
  end

  # ist user ein Treasurer und im privilegierten Modus?
  def active_treasurer?(user, mode)
    user&.treasurer? && mode == 'privileged'
  end

  # ist user ein Auditor und im privilegierten Modus?
  def active_auditor?(user)
    user&.auditor? && mode == 'privileged'
  end
end
