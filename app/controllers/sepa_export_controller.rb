class SepaExportController < ApplicationController
	include SepaExportHelper
	before_action :basic_authorization, :extract_parameters

	def extract_parameters
		if params[:event_id]
			@event = Event.find(params[:event_id])
			breadcrumb Event.model_name.human(count: :other), :events_path
			breadcrumb @event.title, @event
			breadcrumb "SEPA-Export", sepa_export_path(event_id: @event)
		else
			if params[:year]
				@year = params[:year].to_i
			else
				@year = Date.today.year
			end
			breadcrumb Person.model_name.human(count: :other), :people_path
			breadcrumb "SEPA-Export Mitgliedschaft #{@year}", sepa_export_path(year: @year)
		end
	end

	def find_transactions
		if @event
			@transactions = get_transactions_for_event @event
		else
			@transactions = get_transactions_for_members @year
		end
	end

	def export
		to_use = params[:transactions].values.select {|transaction| transaction[:use] == "1"}
		add_persons to_use
		execution_date = Date.parse(params[:execution_date])
		sepa_direct_debit = create_direct_debit to_use, execution_date

		if params[:notify] == "1"
			notify_debtors to_use, execution_date
		end

		if params[:set_used] == "1"
			use_mandates to_use
		end

		send_data sepa_direct_debit.to_xml,
							:filename => filename,
							:type => "application/xml"
	end

	def verify
		find_transactions
	end

	def basic_authorization
		authorize :banking, :sepa_export?
	end
end
