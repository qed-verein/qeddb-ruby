# frozen_string_literal: true

json.type :ChargeModifier
json.extract! charge_modifier, :id, :money_amount, :reason, :comment
if modules.include? :registration_summary
  json.registration_summary do
    json.partial! 'registrations/registration_summary_for_event', registration: charge_modifier.registration,
                                                                  modules: [:person_summary]
  end
end
