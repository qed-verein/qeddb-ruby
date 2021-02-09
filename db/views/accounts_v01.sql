/* Erzeugt eine SQL-View, welche für jede Berechtigunsgruppe
wie Homepage, Gallery eine Liste aller Accounts liefert */
SELECT
	groups.title AS group_title,
	people.id AS account_id,
	people.account_name AS account_name,
	people.crypted_password AS crypted_password,
	people.email_address AS email_address
FROM recursive_members AS m, groups, people
WHERE m.group_id = groups.id AND m.person_id = people.id;
