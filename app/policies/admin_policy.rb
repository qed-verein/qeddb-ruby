# frozen_string_literal: true

# Das allgemiene Berechtigungskonzept für verschiedene Adminbereichte
# Wird zum Konfigurieren von Gruppen, Emailverteiler und Versionsständen hergenommen

class AdminPolicy
  include PunditImplications

  define_implications({
                        viewable: %i[show index],
                        editable: %i[viewable edit new edit destroy]
                      })
  alias update? edit?
  alias create? new?

  def initialize(user, _object)
    return unless user.admin? || user.chairman?

    grant :editable
  end
end
