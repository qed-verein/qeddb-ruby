# qeddb-ruby
Die QEDDB-RUBY ist die neue Mitgliederverwaltung für den Quod Erat Demonstrandum e.V. (https://www.qed-verein.de)

Die Implementierung erfolgte mit Ruby on Rails Version 6 (https://rubyonrails.org/)

Voraussetzungen
============

* ruby mit Version >= 2.5.0
* bundle
* yarn
* sqlite mit Version >= 3


Installation
============

Im GIT-Repository sind lediglich die Quelltextdateien für die QEDDB.
Die zugehörigen Abhängigkeiten sind *nicht* im GIT-Repositiry enthalten. Diese können nach dem Klonen mit

    bundle config set --local path 'vendor/bundle'
    bundle install

ins Verzeichnis vendor/bundle nachinstalliert werden. Zur Installation muss das Ruby-Paket bundle zur Verfügung stehen.
Anschließend müssen die JavaScript-Abhängigkeiten mit yarn installiert werden

    yarnpkg install

Datenbanksetup
==============

Möchte man MYSQL benutzen, so muss vorher "ruby db/mysql_patch.rb" ausgeführt werden.
Falls noch keine Datenbank erstellt wurde, muss anschließend

    bin/rails db:setup

aufgerufen werden. Dieser Befehl erstellt auch einen Benutzer "Admin" mit Passwort "mypassword".
Anschließend lassen sich zum Rumspielen die Daten der Testcases importieren.

    bin/rails db:fixtures:load

Konfiguration
======================
In config/application.rb befinden sich die Einstellungen zum Konfigurieren

Beim Updaten
======================
Neue Abhängigkeiten herunterladen
 bundle update
Neue CSS/JS vorcompilieren
 rake assets:precompile
Migrations laufen lassen
 rails db:migrate

Verzeichnisstruktur
======================
* `app`    - Hier befindet sich der eigentliche Programmcode
  * `assets`     - Für CSS und JS
  * `controller` - Hier kommen die Routinen für Benutzeraktionen rein.
  * `helpers`    - Verschiedene Hilfsroutinen
  * `mailers`    - Routinen für Emails
  * `models`     - Hier kommen Klassen zur Datenverwaltung rein
  * `policies`   - Rechteverwaltung
  * `views`      - Hier kommen HTML-Templates für die Anzeige rein
* `bin`    - Für Programme von Ruby-on-Rails
* `config` - Die Konfigurationseinstellungen befinden sich hier
* `db`     - Für Datenbankschemas und SQLITE-Dateien
* `log`    - Logging
* `public` - Diese Dateien können aus dem Internet abgerufen werden
* `test`   - Für das automatische Abarbeiten von Testcases
* `tmp`    - Temporäre Dateien
  * `mail` - Hier landen die Emails, wenn man im Developmentmode ist
* `vendor` - Abhängigkeiten für die QEDDB und Ruby-on-Rails