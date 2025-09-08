class ApplicationPolicy
  attr_reader :user_context, :record

  def initialize(user_context, record)
    @user = user_context.user
    @mode = user_context.mode
    @record = record
  end
end
