class EventsController < ApplicationController
  include AddressesHelper

  breadcrumb Event.model_name.human(count: :other), :events_path

  before_action :set_all_events, only: %i[index index_as_table]
  before_action :set_event, except: %i[index new create index_as_table]
  before_action :set_payments, only: [:finances]
  before_action :basic_permission_check

  def index; end

  def index_as_table
    render 'as_table'
  end

  def finances
    render 'finances'
  end

  def edit_payments; end

  def show; end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(permitted_attributes(Event))
    if @event.save
      redirect_to @event, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @event.update(permitted_attributes(@event))
      redirect_to @event, notice: t('.success')
    else
      pages = %w[edit edit_payments]
      action = pages.include?(params[:formular]) ? params[:formular] : 'edit'
      render action
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: t('.success')
  end

  def registrations_as_table
    render :registrations
  end

  def edit_own_registration
    registration = Registration.find_by(event: @event, person: current_user)
    if registration
      redirect_to self_registration_path(registration), notice: t('.already_registered')
    else
      redirect_to event_path(@event), notice: t('.not_registered')
    end
  end

  private

  def basic_permission_check
    case action_name.to_sym
    when :registrations_as_table
      authorize @event, :view_event?
      authorize @event, :list_participants?
    when :finances
      authorize @event, :view_payments?
    when :show
      authorize @event, :view_basic?
    when :new, :create
      authorize Event, :create_event?
    when :edit, :update
      authorize @event, :edit_event?
    when :destroy
      authorize @event, :delete_event?
    when :index, :index_as_table
      authorize Event, :list_events?
    when :edit_own_registration
      skip_authorization
    when :edit_payments
      authorize @event, :edit_payments?
    else
      raise Pundit::NotAuthorizedError, "Event/#{action_name} not authorized"
    end
  end

  def set_event
    @event = Event.find(params[:id])
    @registration_of_current_user = current_user.registrations.find_by(event: @event)
    @event_policy = policy(@event)
    breadcrumb @event.title, @event
  end

  def set_all_events
    @events = Event.includes(:organizers, :participants, :hostel).all
  end

  def set_payments
    registration_payments = RegistrationPayment.joins(:registration).where(registration: { event_id: @event.id })
    transfers = registration_payments.select { |x| x.payment_type.to_sym == :transfer }
    @transfers = {
      payments: transfers,
      negative: transfers.map(&:money_amount).select(&:negative?),
      positive: transfers.map(&:money_amount).select(&:positive?)
    }
    @payments = (@event.event_payments.all + registration_payments.reject do |x|
      x.category.blank?
    end).group_by(&:category).transform_values do |payments|
      amounts = payments.map(&:money_amount)
      {
        payments: payments,
        sum: amounts.sum,
        positive: amounts.select(&:positive?).sum,
        negative: amounts.select(&:negative?).sum
      }
    end

    open = @event.registrations.map(&:to_be_paid).compact_blank
    @open = {
      positive: open.select(&:positive?),
      negative: open.select(&:negative?)
    }
  end
end
