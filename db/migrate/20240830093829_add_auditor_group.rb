class AddAuditorGroup < ActiveRecord::Migration[6.1]
  def change
  # this fucks shit up because it creates an object with outdated field names.
  # 
  # in general, using the ORM like this in migrations is probably not a good idea -
  # it relies on a specific version of the application model code, and also 
  # just leads to messing up the cache of the columns, breaking everything if
  # a later migration e.g. renames them, or adds new columns.
  #
  # a more manual way of creating rows using e.g. direct SQL statements
  # would probably work.
  #
  # we already create an auditor group in seeds.rb for test deployments, and surely
  # prod has one too. therefore dummied out.

  #  Group.create!({ id: 9, title: 'Kassenprüfer:innen', mode: :editable, program: :auditors,
  #                  description: 'Diese Gruppe enthält die Kassenprüfer:innen des QEDs NUR während der Kassenprüfung' })
  end
end
