# Configurable hooks
Rails.application.config.qeddb_hooks = {
    person_created: Proc.new {|person| printf "Person created: %s\n", person.account_name},
    person_deleted: Proc.new {|person| printf "Person deleted: %s\n", person.account_name},
}