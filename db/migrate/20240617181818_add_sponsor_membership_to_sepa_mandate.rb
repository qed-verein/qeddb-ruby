# frozen_string_literal: true

class AddSponsorMembershipToSepaMandate < ActiveRecord::Migration[6.1]
  def change
    add_column :sepa_mandates, :sponsor_membership, :decimal, null: true
    add_column :sepa_mandates, :allow_all_payments, :boolean, default: true
  end
end
