class AddAuditorGroup < ActiveRecord::Migration[6.1]
  def change
  # this fucks shit up because it creates an object with outdated field names.
  # we already create an auditor group in seeds.rb for test deployments, and surely
  # prod has one too. therefore dummied out.

  #  Group.create!({ id: 9, title: 'Kassenprüfer:innen', mode: :editable, program: :auditors,
  #                  description: 'Diese Gruppe enthält die Kassenprüfer:innen des QEDs NUR während der Kassenprüfung' })
  end
end
