class AddMoneyTransferDateToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :transfer_date, :date
    up_only do
      Payment.reset_column_information
      Payment.where('start = end').update_all('transfer_date = start')
      Payment.where(transfer_date: nil).each do |payment|
        if /(\d\d).(\d\d).(20\d\d)/.match(payment.comment) then
          payment.update!(transfer_date: Date.new($3.to_i,$2.to_i,$1.to_i))
        end
      end
    end
  end
end
