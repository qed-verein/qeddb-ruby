DatabasePolicy = Struct.new(:user, :database) do
  include PunditImplications
  include PolicyHelper

  define_implications(
    {
      by_admin: %i[import export]
    }
  )

  def initialize(user_context, _object)
    super
    return unless active_admin?(@user, @mode) || active_chairman?(@user, @mode)

    grant :by_admin
  end
end
