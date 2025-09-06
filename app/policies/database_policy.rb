# frozen_string_literal: true

DatabasePolicy = Struct.new(:user, :database) do
  include PunditImplications

  define_implications(
    {
      by_admin: %i[import export]
    }
  )

  def initialize(user, _object)
    return unless user.admin? || user.chairman?

    grant :by_admin
  end
end
