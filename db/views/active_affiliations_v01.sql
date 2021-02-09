-- Liefert die Liste aller momentan gültigen Gruppenzugehörigkeiten
SELECT group_id, groupable_type, groupable_id
FROM affiliations
WHERE (start IS NULL OR start <= DATETIME('now'))
	AND (end IS NULL OR end >= DATETIME('now'));
