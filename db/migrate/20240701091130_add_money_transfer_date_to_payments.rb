# frozen_string_literal: true

class AddMoneyTransferDateToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :transfer_date, :date
    up_only do
      Payment.reset_column_information
      Payment.where('start = end').update_all('transfer_date = start')
      Payment.where(transfer_date: nil).each do |payment|
        next unless /(\d\d).(\d\d).(20\d\d)/.match(payment.comment)

        payment.update!(transfer_date: Date.new(
          ::Regexp.last_match(3).to_i,
          ::Regexp.last_match(2).to_i,
          ::Regexp.last_match(1).to_i
        ))
      end
    end
  end
end
