class EventsController < ApplicationController
	include AddressesHelper

	breadcrumb Event.model_name.human(count: :other), :events_path

	before_action :set_all_events, only: [:index, :index_as_table]
	before_action :set_event, except: [:index, :new, :create, :index_as_table]
	before_action :basic_permission_check

	def index
	end

	def index_as_table
		render 'as_table'
	end

	def show
	end

	def new
		@event = Event.new
	end

	def edit
	end

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
			render :edit
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
			redirect_to self_registration_path(registration), notice:
				"Du bist bereits zu dieser Veranstaltung angemeldet. Leite zur bestehender Anmeldung weiter"
		else
			redirect_to event_path(@event), notice: "Anmeldung nicht gefunden."
		end
	end

	private

	def basic_permission_check
		case action_name.to_sym
			when :registrations_as_table
				authorize @event, :view_event?
				authorize @event, :list_participants?
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
			else
				raise Pundit::NotAuthorizedError, "Event/" + action_name.to_s + " not authorized"
		end
	end

	def set_event
		@event = Event.find(params[:id])
		@event_policy = policy(@event)
		breadcrumb @event.title, @event
	end

	def set_all_events
		@events = Event.includes(:organizers, :participants, :hostel).all
	end
end
