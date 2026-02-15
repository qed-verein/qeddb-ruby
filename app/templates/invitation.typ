#import "./common/letter.typ": letter, subject, sender

#show: letter
#sender[#(sys.inputs.at("absender"))]
#subject[Bitte um Unterrichtsbefreiung]

Sehr geehrte Schulleitung,

// Die gendern Funktion braucht die unformatierten Werte -> benutzt _Geschlecht_TN
Ihr:e Schüler:in #(sys.inputs.at("name")) möchte vom #(sys.inputs.at("event.start")) bis zum #(sys.inputs.at("event.end")) an einem QED-Mathematik-Seminar
#if sys.inputs.keys().contains("event.ort") [
    in #(sys.inputs.at("event.ort"))
]
teilnehmen.

Der Quod Erat Demonstrandum e.V. ist ein bayernweiter Schüler:innen- und Studierendenverein, der sich der Begabtenförderung in der Mathematik verschrieben hat.
Jährlich werden fünf Seminare und zwei einwöchige Akademien veranstaltet, auf denen begabte Schüler Mathematik weit jenseits des Schulstoffes erlernen und sich gegenseitig austauschen können.
Für dieses Engagement erhielt der Verein 2009 den Karg-Preis für Begabtenförderung.
Genauere Informationen über unseren Verein finden Sie unter #(sys.inputs.at("homepage")).

Da uns durch die langen Anreisewege viel Zeit verloren geht, sind unsere Seminare immer mehrtägig.
Daher bitten wir Sie, #(sys.inputs.at("name")) im genannten Zeitraum vom Unterricht zu befreien.

Mit freundlichen Grüßen
#block(inset: (x: 1cm, y: 0.5cm))[
  #(sys.inputs.at("orga"))\
  Organisator:in der Veranstaltung
]
