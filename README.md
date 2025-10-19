# qeddb-ruby
Die QEDDB-RUBY ist die neue Mitgliederverwaltung für den Quod Erat Demonstrandum e.V. (https://www.qed-verein.de)

Die Implementierung erfolgte mit Ruby on Rails Version 6 (https://rubyonrails.org/)

Voraussetzungen
============

* ruby mit Version >= 3.0.0
* yarn
* mysql
* sqlite mit Version >= 3


Installation
============

Im GIT-Repository sind lediglich die Quelltextdateien für die QEDDB.
Die zugehörigen Abhängigkeiten sind *nicht* im GIT-Repository enthalten. Diese können nach dem Klonen mit

    gem install bundle
    bundle config set --local path 'vendor/bundle'
    bundle install

ins Verzeichnis vendor/bundle nachinstalliert werden. Zur Installation muss das Ruby-Paket bundle zur Verfügung stehen.
Anmerkung für MacOS: Vor `bundle install` muss zusätzlich folgender Befehl ausgeführt werden, damit die Installation von `mysql2` funktioniert:

    bundle config --local build.mysql2 "--with-opt-dir=$(brew --prefix openssl) --with-ldflags=-L/opt/homebrew/opt/zstd/lib --with-cflags='-Wno-incompatible-function-pointer-types -Wno-error=implicit-function-declaration'"

Anschließend müssen die JavaScript-Abhängigkeiten mit yarn installiert werden

    yarnpkg install

Datenbanksetup
==============

Falls noch keine Datenbank erstellt wurde, muss anschließend

    bin/rails db:setup

aufgerufen werden. Dieser Befehl erstellt auch einen Benutzer "Admin" mit Passwort "mypassword".
Anschließend lassen sich zum Rumspielen die Daten der Testcases importieren.

    bin/rails db:fixtures:load

Testnutzernamen: Admin, carlfriedrichgauss, leonhardeuler, pierredefermat, Testadmin, Testextern, Testkassenprüferin, Testkassier, Testmitglied, Testvorstand

Der Server kann jetzt lokal gestartet werden:

    bin/rails server

Die Unit Tests können mit diesem Befehl ausgeführt werden:

    bin/rails test

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
