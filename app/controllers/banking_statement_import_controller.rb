class BankingStatementImportController < ApplicationController
	include BankingStatementImportHelper
	before_action :basic_authorization

	breadcrumb 'import', :import_path

	def prepare
		@import_errors = ""
	end

	def import
		@import_errors = ""

		stream = params[:import_file]
		return if stream.nil?

		@import_errors = import_banking_csv(stream.read)

		render :prepare
	end

	private

	def basic_authorization
		authorize :database, :import_banking_statement?
	end
end
