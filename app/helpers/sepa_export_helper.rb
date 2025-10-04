module SepaExportHelper
  def sepa_export_button(event_id = nil, year = nil)
    return nil unless policy(:banking).sepa_export?

    icon_button t('actions.export_sepa.prepare'), 'attach_money', sepa_export_path(event_id: event_id, year: year)
  end

  def get_transactions_for_members(year)
    cutoff_date = Time.zone.local(year).beginning_of_year
    Person
      .where(paid_until: ..cutoff_date)
      .where(member_until: cutoff_date..)
      .where.not(sepa_mandate: nil)
      .joins(:sepa_mandate)
      .where(sepa_mandate: { sponsor_membership: nil })
      .to_a
      .map do |person|
      {
        person: person,
        reference_line: "Mitgliedschaft #{year}, #{person.reference_line}",
        amount: Rails.configuration.membership_fee,
        instruction: "M#{year} #{person.id}"
      }
    end +
      Person
      .where.not(sepa_mandate: nil)
      .joins(:sepa_mandate)
      .where.not(sepa_mandate: { sponsor_membership: nil })
      .to_a
      .map do |person|
        {
          person: person,
          reference_line: "Foerdermitgliedschaft #{year}, #{person.reference_line}",
          amount: person.sepa_mandate.sponsor_membership + (
            person.paid_until < cutoff_date ? Rails.configuration.membership_fee : 0
          ),
          instruction: "F#{year} #{person.id}"
        }
      end
  end

  def get_transactions_for_event(event)
    event
      .registrations
      .joins(person: :sepa_mandate)
      # Falls Leute NUR der Abbuchung der Fördermitgliedschaft zugestimmt haben,
      # dürfen wir sie keine Events damit zahlen lassen.
      .where(sepa_mandates: { allow_all_payments: true })
      .reject { |registration| registration.to_be_paid <= 0 }
      .map do |registration|
      {
        person: registration.person,
        reference_line: registration.reference_line,
        amount: registration.to_be_paid,
        instruction: "E#{event.id} #{registration.person.id}"
      }
    end
  end

  def add_persons(transactions)
    transactions.each do |transaction|
      transaction[:person] = Person.find(transaction[:person_id])
    end
  end

  def create_direct_debit(transactions, execution_date)
    sdd = SEPA::DirectDebit.new(
      name: Rails.configuration.banking_name,
      bic: Rails.configuration.bic,
      iban: Rails.configuration.iban,
      creditor_identifier: Rails.configuration.creditor_id
    )

    transactions.each do |transaction|
      sdd.add_transaction(
        name: transaction[:person].sepa_mandate.name_account_holder,
        iban: transaction[:person].sepa_mandate.iban,
        amount: transaction[:amount],
        remittance_information: transaction[:reference_line],
        mandate_id: transaction[:person].sepa_mandate.mandate_reference,
        mandate_date_of_signature: transaction[:person].sepa_mandate.signature_date,
        reference: transaction[:instruction],
        instruction: transaction[:instruction],
        local_instrument: 'CORE',
        sequence_type: 'FRST',
        requested_date: execution_date.to_date,
        batch_booking: true
      )
    end
    sdd
  end

  def notify_debtors(transactions, execution_date)
    transactions.each do |transaction|
      mailer = SepaMailer.with(
        person: transaction[:person],
        execution_date: execution_date,
        amount: transaction[:amount],
        reference_line: transaction[:reference_line]
      )
      mailer.sepa_direct_debit_announce_email.deliver_now
    end
  end

  def use_mandates(transactions)
    transactions.each do |transaction|
      transaction[:person].sepa_mandate.use_mandate
    end
  end

  def filename
    if @event
      "SEPA_#{@event.title}.xml"
    else
      "SEPA_Mitgliedschaft_#{@year}.xml"
    end
  end
end
