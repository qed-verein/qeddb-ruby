class FinanceReviewController < ApplicationController
	before_action :basic_authorization
	before_action :set_events
	before_action :set_payments

	def show; end

	private

	def set_events
		@events = Event.all
	end

	def set_payments
		@filter = {
			reason: params.dig(:finance_review, :reason) || "",
			start: parse_date(params.dig(:finance_review, :start), Date.today.beginning_of_year),
			end: parse_date(params.dig(:finance_review, :end), Date.today.end_of_year)
		}
		date_range = @filter[:start]..@filter[:end]
		@payments = membership_payments(date_range) + registration_payments(date_range)
	end

	def registration_payments(date_range)
		case @filter[:reason]
		when ""
			RegistrationPayment.where(money_transfer_date: date_range) + EventPayment.where(money_transfer_date: date_range)
		when "membership"
			[]
		else
			RegistrationPayment.joins(:registration).where(registration: {:event_id => @filter[:reason]}, money_transfer_date: date_range) +
			 EventPayment.where(:event_id => @filter[:reason], money_transfer_date: date_range)
		end
	end

	def membership_payments(date_range)
		if @filter[:reason].blank? || @filter[:reason] == "membership"
			Payment.where(transfer_date: date_range)
		else
			[]
		end
	end

	def parse_date(date_input, fallback)
		# Default to fallback if the date is not provided and to nil if it is empty
		case date_input
		when nil
			fallback
		when ""
			nil
		else
			Date.parse(date_input)
		end
	end

	def basic_authorization
		authorize :finance_review, :view?
	end
end
