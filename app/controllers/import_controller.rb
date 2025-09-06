class ImportController < ApplicationController
  include ImportHelper
  before_action :basic_authorization

  breadcrumb 'import', :import_path

  def prepare
    @import_errors = ''
  end

  def import
    @import_errors = ''

    stream = params[:import_file]
    return if stream.nil?

    json = JSON.parse(stream.read, { symbolize_names: true })
    @import_errors = import_json(json)

    if @import_errors.empty?
      redirect_to import_path, notice: 'Import erfolgreich'
    else
      render :prepare
    end
  end

  private

  def basic_authorization
    authorize :database, :import?
  end
end
