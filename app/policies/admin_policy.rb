# Das allgemiene Berechtigungskonzept für verschiedene Adminbereichte
# Wird zum Konfigurieren von Gruppen, Emailverteiler und Versionsständen hergenommen

class AdminPolicy < ApplicationPolicy
  include PunditImplications
  include PolicyHelper

  define_implications({
                        viewable: %i[show index],
                        editable: %i[viewable edit new destroy]
                      })
  alias update? edit?
  alias create? new?

  def initialize(user_context, _object)
    super
    return unless active_admin?(@user, @mode) || active_board_member?(@user, @mode)

    grant :editable
  end
end
