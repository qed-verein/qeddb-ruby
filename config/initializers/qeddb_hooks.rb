# Configurable hooks
Rails.application.config.qeddb_hooks = {
  person_created: proc { |person| printf "Person created: %s\n", person.account_name },
  person_deleted: proc { |person| printf "Person deleted: %s\n", person.account_name }
}
