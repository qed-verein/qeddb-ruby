/* Erzeugt eine SQL-View, welche für jede Gruppe alle darin enthaltenen Personen zurückliefert.
   Dabei werden auch automatisch verwaltete Gruppen sowie  rekursive Beziehungen von
   verschachtelten Gruppen berücksichtigt */
WITH RECURSIVE
-- Liste der automatisch eingetragenen Gruppenmitglieder
automatic_members(group_id, person_id) AS (
	SELECT groups.id, registrations.person_id
	FROM groups, registrations
	WHERE groups.event_id = registrations.event_id AND
		((groups.program = 7 AND registrations.organizer) OR
		 (groups.program = 8 AND registrations.status IN (1, 2)))
	UNION
	SELECT groups.id, people.id
	FROM groups, people
	WHERE (groups.program = 4 AND people.active AND (CURRENT_TIMESTAMP BETWEEN people.joined AND people.member_until)) OR
		  (groups.program = 5 AND people.active AND (NOT CURRENT_TIMESTAMP BETWEEN people.joined AND people.member_until OR
				people.joined IS NULL OR people.member_until IS NULL)) OR
		  (groups.program = 6 AND people.active AND people.newsletter)),
-- Liste der manuell eingetragenen Gruppenmitglieder
direct_members(group_id, person_id) AS (
	SELECT group_id, groupable_id FROM active_affiliations
	WHERE groupable_type = 'Person'
	UNION
	SELECT * FROM automatic_members),
-- Liste aller momentanen Mitgleider einer Gruppe (auch rekursiv durch Untergruppen)
recursive_members_relation(group_id, person_id) AS (
	SELECT DISTINCT r.group_id, d.person_id
	FROM recursive_subgroups AS r, direct_members AS d
	WHERE d.group_id = r.descendant_id)
SELECT * FROM recursive_members_relation;
