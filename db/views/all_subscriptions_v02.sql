/* Erzeugt eine SQL-View, welche für jede Emailverteiler
eine Liste aller eingetragenen Emailadressen mit zugehörigen Rechten liefert.
Dabei werden auch automatische eingetragenen Emailadressen beachtet. */
WITH
-- Sendergruppe einer Mailingliste
senders(mailinglist_id, email_address, first_name, last_name) AS (
	SELECT ml.id, p.email_address, p.first_name, p.last_name
	FROM recursive_members AS gp, mailinglists AS ml, people AS p
	WHERE gp.person_id = p.id AND gp.group_id = ml.sender_group_id),
-- Empfängergruppe einer Mailingliste
receivers(mailinglist_id, email_address, first_name, last_name) AS (
	SELECT ml.id, p.email_address, p.first_name, p.last_name
	FROM recursive_members AS gp, mailinglists AS ml, people AS p
	WHERE gp.person_id = p.id AND gp.group_id = ml.receiver_group_id),
-- Moderatorengruppe einer Mailingliste
moderators(mailinglist_id, email_address, first_name, last_name) AS (
	SELECT ml.id, p.email_address, p.first_name, p.last_name
	FROM recursive_members AS gp, mailinglists AS ml, people AS p
	WHERE gp.person_id = p.id AND gp.group_id = ml.moderator_group_id),
-- Alle über Gruppen automatisch eintragenen Sender, Empfänger und Moderatoren
automatic(mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator) AS (
	SELECT mailinglist_id, email_address, first_name, last_name, MAX(as_sender) = 1, MAX(as_receiver) = 1, MAX(as_moderator) = 1 FROM (
		SELECT *, 1 AS as_sender, 0 AS as_receiver, 0 AS as_moderator FROM senders UNION
		SELECT *, 0 AS as_sender, 1 AS as_receiver, 0 AS as_moderator FROM receivers UNION
		SELECT *, 0 AS as_sender, 0 AS as_receiver, 1 AS as_moderator FROM moderators) AS flag_table
	GROUP BY mailinglist_id, email_address),
-- Einzlne Mitglieder
members(mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator) AS (
	SELECT mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator
	FROM mailinglist_members AS mm, people AS p
	WHERE mm.person_id = p.id
),

-- Manuelle Änderungen an der Mailingliste
manual(mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator) AS (
	SELECT mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator
	FROM subscriptions)
SELECT mailinglist_id, email_address, first_name, last_name, as_sender, as_receiver, as_moderator, MAX(m) AS manual
FROM (
	SELECT *, 2 AS m FROM manual UNION
	SELECT *, 1 AS m FROM members UNION
	SELECT *, 0 AS m FROM automatic) AS combination_table
GROUP BY mailinglist_id, email_address
