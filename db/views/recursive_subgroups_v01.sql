/* Erzeugt eine SQL-View, welche für jede Gruppe alle hinzugefügten Untergruppen
zurückliefert. Dabei werden auch mehrfach ineinander geschachtelte Gruppen berücksichtigt. */
WITH RECURSIVE
-- Liste der direkt eingetragen Untergruppen
direct_subgroups(group_id, child_id) AS (
	SELECT group_id, groupable_id FROM active_affiliations
	WHERE groupable_type = 'Group'),
-- Liste aller enthaltenen Untergruppen (auch rekursiv geschachtelt)
recursive_subgroups_relation(group_id, descendant_id) AS (
	SELECT id, id FROM groups
	UNION
	SELECT DISTINCT d.group_id, r.descendant_id
	FROM direct_subgroups AS d, recursive_subgroups_relation AS r
	WHERE d.child_id = r.group_id)
SELECT * FROM recursive_subgroups_relation;
