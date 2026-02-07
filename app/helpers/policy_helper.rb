module PolicyHelper
  # ist user ein Admin und im privilegierten Modus?
  def active_admin?(user, mode)
    user&.admin? && mode == 'privileged'
  end

  # ist user ein board_member und im privilegierten Modus?
  def active_board_member?(user, mode)
    user&.board_member? && mode == 'privileged'
  end

  # ist user ein Treasurer und im privilegierten Modus?
  def active_treasurer?(user, mode)
    user&.treasurer? && mode == 'privileged'
  end

  # ist user ein Auditor und im privilegierten Modus?
  def active_auditor?(user, mode)
    user&.auditor? && mode == 'privileged'
  end
end
