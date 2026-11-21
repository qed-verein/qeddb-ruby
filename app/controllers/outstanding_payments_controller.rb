class OutstandingPaymentsController < ApplicationController
  breadcrumb I18n.t('actions.outstanding_payments.view'), :outstanding_payments_path

  before_action :basic_authorization
  before_action :set_registrations

  def show; end

  private

  def set_registrations
    @registrations = Registration.all
                                 .reject(&:fully_paid?)
                                 .reject { |registration| registration.to_be_paid.nil? }
  end

  def basic_authorization
    authorize :outstanding_payments, :view?
  end
end
