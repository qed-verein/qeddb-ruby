class ExportController < ApplicationController
	before_action :basic_authorization

	breadcrumb 'export', :export_path

	def prepare
	end

	def export
		@export_people = params[:export_people]
		@export_events = params[:export_events]
		@export_registrations = params[:export_registrations]
		@export_groups = params[:export_groups]
		@export_mailinglists = params[:export_mailinglists]

		if @export_people then
			@people = Person.includes(:addresses, :contacts, :payments).all
		end

		if @export_events || @export_registrations then
			if @export_registrations
				@events = Event.includes(registrations: :person).all
			else
				@events = Event.all
			end
			@hostels = Hostel.includes(:address).all
		end

		if @export_groups then
			@groups = Group.includes(:timeless_entries).all
		end

		if @export_mailinglists then
			@mailinglists = Mailinglist.includes(:subscriptions).all
		end

		#output = render_to_string("export/export")
		#send_data output, type: :json , disposition: "attachment; filename=export.json"
	end

	private

	def basic_authorization
		authorize :database, :export?
	end
end
