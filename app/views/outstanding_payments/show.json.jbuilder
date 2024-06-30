authorize_json_export(policy(:outstanding_payments), json) {
    json.array! @registrations, partial: 'registrations/registration', as: :registration, locals: {modules: [:person_summary, :event_summary]}
}

