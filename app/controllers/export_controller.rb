# frozen_string_literal: true

class ExportController < ApplicationController
  before_action :basic_authorization

  breadcrumb 'export', :export_path

  def prepare; end

  def export
    @export_people = params[:export_people]
    @export_events = params[:export_events]
    @export_registrations = params[:export_registrations]
    @export_groups = params[:export_groups]
    @export_mailinglists = params[:export_mailinglists]

    @people = Person.includes(:addresses, :contacts, :payments).all if @export_people

    if @export_events || @export_registrations
      @events = if @export_registrations
                  Event.includes(registrations: :person).all
                else
                  Event.all
                end
      @hostels = Hostel.includes(:address).all
    end

    @groups = Group.includes(:timeless_entries).all if @export_groups

    return unless @export_mailinglists

    @mailinglists = Mailinglist.includes(:subscriptions).all

    # output = render_to_string("export/export")
    # send_data output, type: :json , disposition: "attachment; filename=export.json"
  end

  private

  def basic_authorization
    authorize :database, :export?
  end
end
