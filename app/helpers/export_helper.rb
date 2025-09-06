# frozen_string_literal: true

module ExportHelper
  def export_link
    return unless policy(:database).export?

    link_to t('actions.export.prepare'), export_path
  end
end
