class VersionsController < ApplicationController
  before_action :set_version, only: %i[show revert]
  before_action :basic_authorization

  breadcrumb 'version', :versions_path

  include Pagy::Backend

  def index
    @pagy, @versions = pagy(PaperTrail::Version.order(created_at: 'DESC', id: 'DESC'),
                            items: 50, size: [1, 2, 2, 1])
  end

  def show; end

  def revert; end

  # ~ def revert
  # ~ object = @version.reify(unversioned_attributes: :preserve)
  # ~ if object.nil?
  # ~ redirect_to version_path(@version), notice: "Löschen noch nicht implementiert"
  # ~ return
  # ~ end
  # ~ # TODO Löschen, Assoziationen, Beliebige Diffs, Auth
  # ~ object.save!
  # ~ redirect_to version_path(object.versions.last), notice: "Version wurde zurückgesetzt"
  # ~ end

  private

  def set_version
    @version = PaperTrail::Version.find(params[:id])
  end

  def basic_authorization
    if @version.nil?
      authorize PaperTrail::Version, :index?
    else
      authorize @version, :show?
    end
  end
end
