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
      flash.now[:error] = t('actions.import_banking_statements.reading_failed')
      return render :prepare
    end

    begin
      @results = import_banking_csv(stream.read)
    rescue StandardError => e
      flash[:error]	= t('actions.import_banking_statements.reading_failed') + ": #{e.message}"
    end

    render :prepare
  end

  private

  def basic_authorization
    authorize :banking, :import_banking_statement?
  end
end
