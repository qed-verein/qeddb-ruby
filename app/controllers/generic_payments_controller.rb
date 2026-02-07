class GenericPaymentsController < ApplicationController
  breadcrumb GenericPayment.model_name.human(count: :other), :generic_payments_path

  before_action :set_generic_payment, only: %i[edit update destroy]
  before_action :basic_authorization

  def index
    @generic_payments = GenericPayment.all
  end

  def new
    @generic_payment = GenericPayment.new
  end

  def edit() end

  def create
    @generic_payment = GenericPayment.new(permitted_attributes(GenericPayment))
    if @generic_payment.save
      redirect_to GenericPayment, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @generic_payment.update(permitted_attributes(@generic_payment))
      redirect_to GenericPayment, notice: t('.success')
    else
      render :edit
    end
  end

  def destroy
    @generic_payment.destroy
    redirect_to GenericPayment, notice: t('.success')
  end

  private

  def set_generic_payment
    @generic_payment = GenericPayment.find(params[:id])
  end

  def basic_authorization
    case action_name.to_sym
    when :new, :create
      authorize GenericPayment, :create?
    when :edit, :update
      authorize @generic_payment, :edit?
    when :destroy
      authorize @generic_payment, :delete?
    when :index
      authorize GenericPayment, :view?
    when :edit_payments
      authorize @generic_payment, :edit_payments?
    else
      raise Pundit::NotAuthorizedError, "generic_payment/#{action_name} not authorized"
    end
  end
end
