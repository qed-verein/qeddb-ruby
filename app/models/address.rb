# frozen_string_literal: true

# Die Klasse "Addresse" verwaltet eine Adresse.

class Address < ApplicationRecord
  # Versionskontrolle
  has_paper_trail

  # Die Entität, welcher diese Adresse zugewiesen wird.
  # Kann eine Person oder eine Unterkunft sein (-> polymorpher Verweis)
  belongs_to :addressable, polymorphic: true

  # Validierungen
  validates :addressable, :city, :street_name, :house_number, :postal_code, presence: true
  validates :country, :city, :street_name, length: { maximum: 50 }
  validates :house_number, :postal_code, length: { maximum: 50 }
  validates :address_addition, length: { maximum: 200 }
  validates :priority, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_blank: true

  # Ordne Adressen standardmäßig nach Priorität
  default_scope { order('priority ASC') }

  def object_name
    addressable ? addressable.object_name : 'Address'
  end
end
