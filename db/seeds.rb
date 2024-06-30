# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Person.transaction do
	puts "Create admin user..."
	person = Person.new({
		id:               0,
		first_name:       "Adminis",
		last_name:        "Trator",
		account_name:     "Admin",
		birthday:         Time.current,
		email_address:    "adminsistrator@email.de",
		active:           true,
		gender:           :male,
		comment:          "Der initial angelegte Account zum Administrieren",
		password: "mypassword", password_confirmation: "mypassword"})
	person.save!
end

Group.transaction do
puts "Create default groups..."

# Erstelle die Standardgruppen
group = Group.new({id: 1, title: "Vorstand", mode: :editable, program: :chairman,
	description: "Diese Gruppe enthält alle Vorstände des Vereins"})
group.save!

group = Group.new({id: 2, title: "Kassier", mode: :editable, program: :treasurer,
	description: "Diese Gruppe enthält den Kassier des Vereins"})
group.save!

group = Group.new({id: 3, title: "Webmaster", mode: :editable, program: :admins,
	description: "Diese Gruppe enthält alle Webmaster des Vereins"})
group.timeless_entries << Affiliation.new({groupable_type: 'Person', groupable_id: 0})
group.save!


group = Group.new({id: 4, title: "Mitglieder", mode: :automatic, program: :members,
	description: "Diese Gruppe enthält alle aktuellen Mitglieder des Vereins"})
group.save!

group = Group.new({id: 5, title: "Externe", mode: :automatic, program: :externals,
	description: "Alle eingetragenen externen Personen"})
group.save!

group = Group.new({id: 6, title: "Newsletter an", mode: :automatic, program: :newsletter,
	 description: "Alle Personen, die Newsletter erhalten möchten"})
group.save!

end

puts "Complete!"
