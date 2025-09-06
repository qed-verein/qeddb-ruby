require 'csv'
require 'general_helpers'

module BankingStatementImportHelper
  include GeneralHelpers

  def banking_statement_import_link
    return unless policy(:banking).import_banking_statement?

    link_to t('actions.import_banking_statements.prepare'), import_banking_statement_path
  end

  def parse_reference_line(reference)
    # Our bank adds this garbage string somtimes
    event_str, person_str = reference.gsub(/DATUM \d\d\.\d\d\.\d\d\d\d, \d\d\.\d\d UHR $/, '').split(',')
    raise 'Verwendungszweck enthält kein Trennzeichen.' if person_str.nil?

    person = find_person(person_str.gsub(/ /, ''))

    if event_str.starts_with? 'Mitgliedsbeitrag'
      year = Integer(event_str.match(/\d{4}/)[0])
      return {
        type: :membership,
        year: year,
        person: person
      }
    end
    if event_str.starts_with? 'Foerdermitgliedschaft'
      year = Integer(event_str.match(/\d{4}/)[0])
      return {
        type: :sponsor_membership,
        year: year,
        person: person
      }
    end

    event = find_event(event_str)
    {
      type: :event,
      event: event,
      person: person,
      registration: Registration.find_by(event: event, person: person)
    }
  end

  def find_person(name)
    matches = Person.all.select { |person| person.reference_line.gsub(/ /, '') == name }
    sole_element matches
  rescue StandardError => e
    case e.message
    when 'None'
      raise "Keine Person mit Namen #{name} gefunden."
    when 'Multiple'
      raise "Mehrere Personen mit Namen #{name} gefunden."
    else
      raise "Unbekannter Fehler, bei Personensuche: #{e.message}"
    end
  end

  def find_event(event_str)
    event_str.gsub!(/ /, '')
    event_str.gsub!(/20\d\d/) { |match| match.delete_prefix('20') }
    begin
      sole_element(Event.all.select { |event| event.reference_line.gsub(/ /, '') == event_str })
    rescue StandardError => e
      case e.message
      when 'None'
        raise "Keine Veranstaltung mit Namen #{event_str} gefunden."
      when 'Multiple'
        raise "Mehrere Veranstaltungen mit Namen #{event_str} gefunden."
      else
        raise "Unbekannter Fehler, bei Veranstaltungssuche: #{e.message}"
      end
    end
  end

  def try_parse_e2e_reference(line)
    return nil unless line['Kundenreferenz (End-to-End)'] =~ /^(M|F|E)(\d+) (\d+)$/

    person = Person.find(Integer(::Regexp.last_match(3)))
    id_or_year = Integer(::Regexp.last_match(2))

    if ::Regexp.last_match(1) == 'M'
      {
        type: :membership,
        year: id_or_year,
        person: person
      }
    elsif ::Regexp.last_match(1) == 'F'
      {
        type: :sponsor_membership,
        year: id_or_year,
        person: person
      }
    else
      event = Event.find(id_or_year)
      {
        type: :event,
        event: event,
        person: person,
        registration: Registration.find_by(event: event, person: person)
      }
    end
  end

  def parse_line(line)
    payment_data = try_parse_e2e_reference(line)
    payment_data = parse_reference_line(line['Verwendungszweck']) if payment_data.nil?
    # Be advised: The date we get from the banking csv only contains two digits for the years.
    # The following will parse 68 as 2068 and 69 as 1969, but this seems acceptable since I doubt
    # that all of ruby3, this qeddb and the banking statements will still be around in 2069.
    {
      **payment_data,
      amount: Float(line['Betrag'].gsub(',', '.')),
      payment_date: Time.strptime(line['Buchungstag'], '%d.%m.%y')
    }
  end

  def validate_payment(payment)
    amount = payment[:amount]
    person = payment[:person]
    if payment[:type] == :membership
      unless Rails.configuration.membership_fee == amount
        raise "Mitgliedsbeitrag ist #{Rails.configuration.membership_fee} nicht #{amount}."
      end
      if person.paid_until.to_time.end_of_day >= Time.zone.local(payment[:year]).end_of_year
        raise "Person #{person.full_name} hat schon für das Jahr #{payment[:year]} gezahlt."
      end
    elsif payment[:type] == :sponsor_membership
      unless person.sepa_mandate.sponsor_membership == amount
        raise "Fördermitgliedsbeitrag ist #{person.sepa_mandate.sponsor_membership} nicht #{amount}."
      end
      if person.paid_until >= DateTime.new(payment[:year]).end_of_year.yesterday
        raise "Person #{person.full_name} hat schon für das Jahr #{payment[:year]} gezahlt."
      end
    else
      event = payment[:event]
      registration = payment[:registration]
      raise "Person #{person.full_name} nicht für die Veranstaltung #{event.title} angemeldet." if registration.nil?
      if registration.payment_complete
        raise "Person #{person.full_name} schon für die Veranstaltung #{event.title} bezahlt."
      end

      unless registration.to_be_paid == amount
        raise format(
          'Person %<name>s muss %<to_be_paid>s€ für die Veranstaltung %<event_title>s zahlen, nicht %<amount>s€.',
          name: person.full_name,
          to_be_paid: registration.to_be_paid,
          event_title: event.title,
          amount: amount
        )
      end
    end
  end

  def apply_payment(payment)
    if payment[:type] == :membership
      year_date = Time.zone.local(payment[:year])
      Payment.create(
        person: payment[:person],
        payment_type: :regular_member,
        start: year_date.beginning_of_year,
        end: year_date.end_of_year,
        amount: payment[:amount]
      )
      "Mitgliedschaft für #{payment[:person].full_name} für das Jahr #{payment[:year]} angelegt."
    elsif payment[:type] == :sponsor_membership
      year_date = DateTime.new(payment[:year])
      Payment.create(
        person: payment[:person],
        payment_type: :sponsor_member,
        start: year_date.beginning_of_year,
        end: year_date.end_of_year,
        transfer_date: payment[:payment_date],
        amount: payment[:amount]
      )
      "Fördermitgliedschaft für #{payment[:person].full_name} für das Jahr #{payment[:year]} angelegt."
    else

      registration = payment[:registration]
      registration.add_transfer(payment[:payment_date], payment[:amount])
      registration.status = :confirmed
      registration.save!
      "Veranstaltung #{payment[:event].title} für Person #{payment[:person].full_name} bezahlt."
    end
  end

  def handle_payment_record(record)
    payment = parse_line(record)
    validate_payment payment
    apply_payment payment
  rescue StandardError => e
    e.message
  end

  def prepare_input(data)
    # Ensure that we are utf-8 encoded, banking statements comes as iso-8859
    data = data.force_encoding('ISO-8859-1').encode('UTF-8')
    # Get rid of any kind of bom
    data = data.sub!(/^.*?"/, '"')
    # Remove artifically added comments in references
    data.gsub('SVWZ+', '').gsub('EREF+', '')
  end

  def import_banking_csv(data)
    records = CSV.parse(prepare_input(data), headers: true, col_sep: ';', strip: true)
    results = []
    ActiveRecord::Base.transaction do
      records&.each do |record|
        results.push([record['Verwendungszweck'], record['Betrag'], handle_payment_record(record)])
      end
    end
    results
  end
end
