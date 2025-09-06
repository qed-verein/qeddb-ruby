namespace :changelog do
  desc 'Lösche geloggte Änderungen an der Datenbank nach einer bestimmten Frist für Datenschutz'
  task cleanup_old: :environment do
    period = Rails.application.config.version_log_period
    printf "Lösche geloggte Änderungen älter als: %s.\n", ActiveSupport::Duration.build(period).parts
    result = PaperTrail::Version.where(created_at: ...(Time.current - period)).delete_all
    printf "Es wurden %d geloggte Änderungen gelöscht.\n", result
  end
end
