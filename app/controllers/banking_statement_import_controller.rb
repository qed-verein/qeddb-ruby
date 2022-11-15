class BankingStatementImportController < ApplicationController
	include BankingStatementImportHelper
	before_action :basic_authorization

	breadcrumb 'import', :import_path

	def prepare
		@results = []
	end

	def import
		@results = []

		stream = params[:import_file]

		if stream.nil?
			flash[:error] = t("actions.import_banking_statements.reading_failed")
			return render :prepare
		end

		@results = import_banking_csv(stream.read)

		render :prepare
	end

	private

	def basic_authorization
		authorize :banking, :import_banking_statement?
	end
end
