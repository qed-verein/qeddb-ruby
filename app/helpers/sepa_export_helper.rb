module SepaExportHelper

	def sepa_export_button(event_id = nil, year = nil)
		return nil unless policy(:database).sepa_export?
		icon_button t('actions.export_sepa.prepare'), 'money', sepa_export_path(event_id: event_id, year: year)
	end

	def get_transactions_for_members(year)
		cutoff_date = DateTime.new(year).beginning_of_year
		Person.where(paid_until: ..cutoff_date)
					.where(member_until: cutoff_date..)
					.select {|person| not person.sepa_mandate.nil?}
					.map {|person|
						{
							:person => person,
							:reference_line => "Mitgliedschaft #{year}, #{person.reference_line}",
							:amount => Rails.configuration.membership_fee,
						}
					}
	end

	def get_transactions_for_event(event)
		event.registrations
				 .where(payment_complete: false, money_amount: 1..)
				 .select {|registration| not registration.person.sepa_mandate.nil?}
				 .map {|registration|
					 {
						 :person => registration.person,
						 :reference_line => registration.reference_line,
						 :amount => registration.money_amount,
					 }
				 }
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
				local_instrument: 'CORE',
				sequence_type: 'FRST',
				requested_date: execution_date,
				batch_booking: true,
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
				reference_line: transaction[:reference_line],
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
