class OutstandingPaymentsController < ApplicationController
  before_action :basic_authorization
  before_action :set_registrations

  def show; end

  private

  def set_registrations
    @registrations = Registration.all.reject(&:fully_paid?)
  end

  def basic_authorization
    authorize :outstanding_payments, :view?
  end
end
