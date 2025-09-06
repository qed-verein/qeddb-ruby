# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Diese Helferfunktion ignoriert bei der Formulareingabe eines assoziierten Models
  # alle leeren Felder und löscht diese auch gegebenfalls aus der Datenbank
  def self.reject_blank_entries(attributes, keys = nil)
    keys ||= attributes.keys - %w[id _destroy]
    keys = [keys] unless keys.is_a?(Array)
    if attributes.slice(*keys).values.all?(&:blank?)
      if attributes[:id].present?
        attributes.merge!({ _destroy: true })
        false
      else
        true
      end
    else
      p attributes
      false

    end
  end

  # Helferfunktionen für lokalisierte Enumerations
  def self.human_enum_value(enum_symbol, key)
    return nil if key.nil?

    human_attribute_name("#{enum_symbol}.#{key}")
  end

  def self.human_enum_options(enum_symbol)
    send(enum_symbol).keys.map do |key|
      [human_attribute_name("#{enum_symbol.to_s.singularize}.#{key}"), key]
    end.to_h
  end

  # Kurze Beschreibung des Objekts (wird für den Versions-Log gebraucht)
  # Wird in den Unterklassen Person, Event usw. implementiert
  def object_name
    'Unbekanntes Objekt'
  end
end
