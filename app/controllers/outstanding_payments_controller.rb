class OutstandingPaymentsController < ApplicationController
	before_action :basic_authorization
	before_action :set_event

	def show
	end

	private

	def set_event
		@registrations = Registration.all.reject { |r| r.fully_paid? }
	end

	def basic_authorization
		authorize :outstanding_payments, :view?
	end
end
