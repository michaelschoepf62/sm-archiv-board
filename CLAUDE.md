# Projekt SocialMedia Archiv-Board (Weltbund Österreich)

## Projektzweck

Social-Media-Beiträge ausgewählter Organisationen (Weltbund-Organisationen, BMEIA)
erfassen, im Team sichten und für die Zweitverwertung im Portal des Weltbund
Österreich (Ehrenamt) vorbereiten. Herausgelöst aus dem Projekt KI-MITARBEITER
(Beschluss Michael 31.07.2026); dieses Repo ist seither das führende
Projektgedächtnis für alles rund um das Board und die SocialMedia-Recherche.

Träger: Michael Schöpf (michaelschoepf62 auf GitHub). Ehrenamts-Kontext, kein
Mandantenbezug. Die KI-Team-/Dashboard-Themen liegen weiterhin im Projekt
`/Users/michaelschopf/Documents/Claude/Projects/KI-MITARBEITER` — hier NICHT vermischen.

## Arbeitsregeln (übernommen aus dem Ursprungsprojekt)

- Bei Unklarheiten erst Rückfragen stellen, Umsetzung erst nach Michaels ausdrücklichem GO
- Jede Antwort beginnt mit "Michael" (Kanarienvogel-Regel, siehe globale CLAUDE.md)
- Sprache: Deutsch, echte Umlaute (ä, ö, ü), "ß" korrekt setzen — niemals durch "ss"
  ersetzen; Dateinamen ohne Umlaute
- Keine fiktiven Aussagen: Unbelegtes als [ERHEBUNG ERFORDERLICH] oder [UNVERIFIZIERT]
  kennzeichnen oder weglassen
- Nur lesende Analyse auf den Plattformen: niemals liken, kommentieren, posten
- Trigger von Michael (Groß-/Kleinschreibung egal, lösen die Aktion direkt aus):
  - KIARCH/kiarch: Board öffnen — `open "https://weltbund-archiv.tiiny.site"`
  - KIRECHERCHE/kirecherche bzw. SM-RECHERCHE: Skill `sm-recherche` ausführen

## Die Web-App

- **Live:** https://weltbund-archiv.tiiny.site (Tiiny Host, Solo-Plan, Konto Michael;
  seit 02.08.2026). **Ein Push auf main ist KEIN Deployment mehr** — Änderungen an
  `index.html` werden erst durch einen Upload bei Tiiny Host wirksam. Der Solo-Plan
  hat eine API (`api-docs.tiiny.host`, API-Key im Konto unter Manage Account), über
  die sich das Ausrollen automatisieren lässt — noch nicht eingerichtet
- **Abgelöst:** GitHub Pages (`michaelschoepf62.github.io/sm-archiv-board/`) — seit
  Michael das Repo auf privat gestellt hat, liefert Pages nichts mehr aus
- **Repo:** `michaelschoepf62/sm-archiv-board` (**privat** seit 02.08.2026), lokal
  `/Users/michaelschopf/Documents/Claude/Projects/sm-archiv-board/`; eine einzelne
  `index.html`. Das Repo ist nur noch Quellcode-Ablage, nicht mehr Auslieferung.
  Wichtig: Das Privatstellen schützt den Supabase-Key NICHT — er steht in der
  ausgelieferten `index.html`; Schutz leisten allein die RLS-Regeln
- **Zugriffsmodell (seit 31.07.2026 abends):** LESEN ist öffentlich — ohne Anmeldung
  Tabs Aktiv/Archiv, Details, Text kopieren, Fotos herunterladen; beim ersten Aufruf
  Nutzungs-Disclaimer (einmalige „Verstanden"-Bestätigung via localStorage) plus
  Dauerzeile in der Filterzeile. BEARBEITEN nur nach Anmeldung: Magic Link
  (supabase-js, Version gepinnt mit SRI-Hash), Freischaltung via `rpc/sm_ist_nutzer`;
  angemeldete Redakteure sehen zusätzlich Papierkorb, Markierungen, Statuswechsel,
  Einladen und den Aktualisierungslauf. Je Organisation werden 5 Beiträge gezeigt,
  der Rest über „mehr anzeigen" (je Tab, zuklappbar)
- **Funktionen:** Tabs Aktiv/Archiv/Papierkorb; Standardfilter "letzte 30 Tage"
  (abschaltbar); Detailansicht mit Volltext und Fotos (signierte URLs, 1 h gültig);
  globale Statuswechsel (archivieren/Papierkorb/wiederherstellen/endgültig löschen —
  Löschen entfernt DB-Zeile, Bildzeilen und Storage-Objekte, Vault-Dateien bleiben);
  **persönliche Markierungen je Nutzer**: "übernommen" (grüne Kennzeichnung) und
  "nicht interessant" (blendet für diesen Nutzer aus, über Filterhäkchen reversibel);
  **Nutzer einladen**: legt `sm_nutzer`-Eintrag an und verschickt den Anmeldelink;
  **Text kopieren** je Beitrag: legt Beitragstext plus Quellenzeile (Organisation,
  Datum, Original-Link) in die Zwischenablage, Quellenzeile auch in der Detailansicht
  sichtbar; Dauerhinweis auf die Facebook-Lücke in der Filterzeile;
  Kopfzeile bleibt beim Scrollen fixiert (sticky); Aktionsleiste je Beitrag als
  **Icon-Reihe mit Tooltips** (📄 Details, 📋 Text kopieren — mit Rückfall-Kopierweg
  und Zeitschranke, 📥 Fotos in den Download-Ordner: einzeln als JPG, mehrere als
  eine ZIP-Datei (eigener ZIP-Packer im Board, da Chrome zeitversetzte
  Mehrfach-Downloads blockiert — Fix 01.08.2026), ✔ übernommen,
  🚫/👁 aus-/einblenden, 📦/♻️/🗑️/❌ Statuswechsel);
  im Kopf der Hinweis auf den letzten Lauf (Zeitpunkt, Redakteur, ggf.
  „unvollständig"); für Redakteure zusätzlich „🌐 Webquellen" und „📜 Protokoll"

## Datenhaltung (Supabase-Projekt "my-bench")

- Ref `pysdixrqptnojwqymarb`, Organisation schoepf.consulting; URL + Publishable Key
  stehen in `index.html` und in `SocialMedia/LinkedIn/supabase-config.js` im Vault
- Tabellen: `sm_posts` (urn als Text: LinkedIn-URN-Zahl, Instagram-Shortcode oder
  `fb-<pfbid…>`; dienst, organisation, datum, titel, autor, text, post_url,
  reaktionen, kommentare, reposts, status erfasst/in_bearbeitung/archiviert/papierkorb,
  geloescht_am, vault_pfad), `sm_bilder` (urn, dateiname, storage_url, sort),
  `sm_nutzer` (email, name, aktiv, eingeladen_von), `sm_markierungen`
  (email, urn, markierung uebernommen|nicht_interessant), `sm_laeufe` (manuelle
  Aktualisierungsläufe: angefordert_von, status angefordert|laeuft|fertig|fehler|
  abgebrochen, fortschritt 0–100, status_text; RLS: SELECT für alle (Letzter-Lauf-
  Hinweis im Board), anfordern/eigene wartende abbrechen nur aktive Nutzer, Status
  fortschreiben nur die Automatik-Identität), `sm_protokoll` (Board-Aktionen
  angemeldeter Nutzer: lauf_angefordert|text_kopiert|fotos_geladen, nur eigene
  Zeilen schreibbar, lesbar für alle aktiven Nutzer — Ansicht „📜 Protokoll"),
  `sm_webquellen` (organisation, url, aktiv; Trigger begrenzt auf 10 je
  Organisation; Pflege durch Redakteure über „🌐 Webquellen")
- Storage-Bucket `sm-bilder`: **privat** (seit 31.07.2026), Zugriff über signierte URLs
- **RLS-Modell (31.07.2026, abends gelockert):** Anonym darf LESEN: `sm_posts` und
  `sm_bilder` ohne Papierkorb-Einträge sowie Storage-SELECT auf `sm-bilder` (für
  signierte URLs) — Beschluss Michael 31.07.2026 (öffentliche Lesesicht). ALLE
  Schreibzugriffe, Papierkorb, `sm_nutzer`, `sm_markierungen`, `sm_laeufe` bleiben
  angemeldeten aktiven Nutzern vorbehalten, geprüft über die security-definer-Funktion
  `sm_ist_nutzer()` (Subselect auf die eigene Tabelle in der Policy würde "infinite
  recursion" auslösen — deshalb die Funktion). `sm_markierungen`: jeder nur die
  eigenen Zeilen. (Historie: bis 31.07. früh war anonym ALLES offen inkl. Löschen —
  behobenes Sicherheitsloch; tagsüber alles gesperrt; abends Lesen bewusst geöffnet)
- **Auth-Konfiguration:** Site URL und Redirect URL müssen auf die Board-URL zeigen
  (Supabase-Konsole gehört zum GitHub-Konto michaelschoepf62, Anmeldung GitHub-OAuth
  + TOTP durch Michael). Nach dem Umzug auf Tiiny Host am 02.08.2026 sind sie auf
  `https://weltbund-archiv.tiiny.site` umzustellen — sonst laufen die Magic Links ins
  Leere und die Redakteursfunktionen sind tot. Die `index.html` selbst braucht keine
  Anpassung: Sie bildet den Rücksprung dynamisch aus
  `location.origin + location.pathname`
- **Mail-Versand (seit 31.07.2026):** eigener SMTP über Gmail (`smtp.gmail.com:465`,
  Benutzer `michael@schoepf-consulting.com` mit App-Passwort „Supabase sm-board";
  setzt 2FA des Workspace-Kontos voraus, wurde dafür aktiviert). Absender ist der
  Workspace-Alias `sm-board@schoepf-consulting.com` („SocialMedia Archiv-Board"),
  Mail-Limit 30/h (vorher eingebauter Supabase-Versand mit nur 2/h — Ursache der
  Fehler „email rate limit exceeded")
- Nutzerbestand: `michael@schoepf-consulting.com`, `michael.schoepf@gmail.com`
  (Redakteure) und `sm-automatik@schoepf-consulting.com` (Automatik, s. u.)

## Erfassung: Skill sm-recherche

- Global installiert: `~/.claude/skills/sm-recherche/SKILL.md` — wirkt in jedem Projekt
- **Dienst „Web" (seit 31.07.2026, ohne Chrome):** Quellen stehen seit 01.08.2026 in
  der Tabelle `sm_webquellen` (bis zu 10 URLs je Organisation, gepflegt von den
  Redakteuren im Board); die `_quelle.md` unter `SocialMedia/Web/<Organisation>/`
  liefert nur noch den Bild-Prefix. Startbestand (Freigabe Michael 31.07.2026):
  Weltbund weltbund.at/thema/neuigkeiten, Weltsteirer /stories, Weltkärntner /blog,
  BMEIA Presse/Aktuelles (ALLE Aussendungen, ohne Filter), Weltniederösterreicher
  europa-in-niederoesterreich.at/blog, Europa-Forum Wachau europaforum.at
  (Startseite, kein News-Bereich). urn = `web-` + normalisierte Artikel-URL;
  dienst `web`; bei Chrome-Fehlern laufen die Web-Quellen trotzdem
- Läuft über Michaels angemeldeten Chrome ("Claude in Chrome"): LinkedIn
  (DOM-Extraktion, Datum aus URN >> 22), Instagram (Shortcode-Dekodierung,
  og:image-Trick), Facebook (Foto-Seiten `/photos` mit pfbid-Permalink; seit
  02.08.2026 zusätzlich `/videos` für Video- und Reel-Beiträge: Kachelübersicht
  auslesen statt Einzelansicht, Datum nur relativ verfügbar und daher abgeleitet,
  Videodateien werden nicht geladen. Nicht erfasst bleiben reine Textbeiträge
  ohne Bild und ohne Video — verbleibende Lücke)
- Umfang: alle Beiträge der letzten 30 Tage je Organisation (seit 31.07.2026;
  vorher letzte 5 Posts)
- Duplikatprüfung über die Post-ID gegen `sm_posts` — nichts wird doppelt angelegt
- Ablage dual: Vault (Textdateien .txt + Fotos, Schema siehe Skill) UND Datenbank
- **DB-Zugang seit Abdichtung:** vor jedem Zugriff Login als Automatik-Identität
  (`~/.config/sm-recherche/automatik.json`, POST /auth/v1/token?grant_type=password,
  dann Bearer-Token); nach Login Test-SELECT, sonst Abbruch (Details im Skill)
- Vault-Basisordner: `/Users/michaelschopf/Library/Mobile Documents/com~apple~CloudDocs/
  COWORK-TEAM/02 Arbeitsbereich/03 Ehrenamt/Weltbund Österreich/SocialMedia/`
  (Unterordner LinkedIn/Instagram/Facebook je Organisation, `_quelle.md` je Organisation)

## Läufe nur interaktiv (Beschluss Michael 01.08.2026, endgültig)

- **So startet Michael einen Lauf:** in einer Claude-Sitzung mit angebundenem Chrome
  `/sm-recherche` eingeben (oder Trigger KIRECHERCHE). Kein Board-Knopf, keine
  Automatik, kein Hintergrundjob.
- **Abgeschafft und gelöscht:** launchd-Jobs `com.schoepf.sm-recherche` (8 Uhr) und
  `com.schoepf.sm-lauf-watcher` (Minutentakt) samt Plists und den Skripten
  `automatik.sh` und `lauf-watcher.sh`; im Board der Knopf „🔄 Aktualisieren" mit
  Fortschritts-Overlay. Grund: Kopflose Läufe erreichen die Claude-in-Chrome-
  Erweiterung nicht (dreimal bestätigt 31.07./01.08.2026) — LinkedIn, Instagram und
  Facebook blieben dadurch leer.
- **Geblieben:** Tabelle `sm_laeufe` als Nachweis. Der Skill trägt jetzt SELBST jeden
  Lauf ein (Start → Fortschritt je Organisation → Endstatus) und schreibt einen
  Protokolleintrag; das Board zeigt daraus den Hinweis „Letzter Lauf: … · angefordert
  von …" (öffentlich sichtbar, bei Teilabbruch mit Zusatz „unvollständig").
  Dafür dürfen seit 01.08.2026 die Automatik-Identität
  `sm-automatik@schoepf-consulting.com` (Passwort-Login, in `sm_nutzer`
  freigeschaltet) Zeilen im Namen eines Redakteurs anlegen.
- Voraussetzung für die Chrome-Dienste: Chrome offen, in LinkedIn/Instagram/Facebook
  angemeldet, Claude-in-Chrome mit der Sitzung verbunden. Der Dienst Web läuft
  unabhängig davon.

## Rechtlicher Rahmen Zweitverwertung (Einschätzung 31.07.2026, keine Rechtsberatung)

Übernahme ins Weltbund-Portal ist mit vorheriger Zustimmung der Rechteinhaber zulässig
(öUrhG, insb. § 18a Zurverfügungstellung). Absichern: (1) Zustimmung vom tatsächlichen
Rechteinhaber — Posts enthalten oft Fotos Dritter ("Foto: Rene Strasser",
"© Alexander Wieselthaler"), die Erklärung soll die Rechte an eingebetteten Fotos
mit abdecken; (2) Zustimmung schriftlich dokumentieren mit Umfang, Dauer, Widerruf;
(3) Quellen- und Urhebernennung plus Link zum Original; (4) bei erkennbaren Personen
Bildnisschutz (§ 78 öUrhG) und DSGVO beachten.
**Änderung 31.07.2026 (abends):** Das Board ist auf Michaels Weisung ÖFFENTLICH
lesbar (Beschluss trotz dokumentiertem Hinweis auf § 18a öUrhG — Anmeldepflicht war
zuvor das Schutzargument „interne Arbeitskopie"). Grundlage laut Michael: „Die
Zustimmung ist grundsätzlich erteilt" (Erklärung vom 31.07.2026); ein Disclaimer
überträgt die Einhaltung der Regeln der Organisationen auf die Nutzenden.
[ERHEBUNG ERFORDERLICH: schriftliche Dokumentation der Zustimmungen — die
Zustimmungs-Vorlage aus den offenen Punkten bleibt dafür wichtig.]

## Entscheidungshistorie (Kurzfassung)

- 19.07.2026: Erfassungsschema und Register etabliert (damals .md + `_erfasst.md`)
- 20.07.2026: Textdateien statt .md; Supabase (`sm_posts`/`sm_bilder`) wird führend;
  Archiv-Board als statische Datei ohne Server; Instagram und Facebook eingerichtet
- 26.07.2026: Register `_erfasst.md` stillgelegt (historischer Auszug, nichts löschen)
- 31.07.2026: 30-Tage-Umfang; Web-Board mit Anmeldepflicht + persönlichen Markierungen
  + Einladungsfunktion; RLS-Abdichtung (anonym gesperrt, Bucket privat);
  8-Uhr-Automatik; Auth-URLs gesetzt; Projekt aus KI-MITARBEITER herausgelöst;
  X (Twitter) wird nicht genutzt (Beschluss Michael); Kopierfunktion mit Quellenzeile,
  Facebook-Hinweis und deutsche Mail-Limit-Meldung im Board ergänzt; manueller
  Aktualisierungslauf vom Board (sm_laeufe + Watcher + Fortschrittsbalken); abends:
  öffentliche Lesesicht mit Disclaimer (Zustimmung laut Michael grundsätzlich
  erteilt), Icons statt Knöpfe, fixierte Kopfzeile, 5-plus-mehr je Organisation,
  Dienst „Web" mit sechs freigegebenen Quellen
- 01.08.2026: Fix Mehrfach-Foto-Download (ZIP) und Zwischenablage-Rückfall;
  Weltkärntner-Galerie vollständig nachgeholt (40 Fotos); Protokoll (`sm_protokoll`
  + Ansicht) und Webquellen-Verwaltung (`sm_webquellen`, max. 10 je Organisation)
  eingeführt; **alle Automatik abgeschafft** — 8-Uhr-Job, Watcher und Board-Knopf
  entfernt, Läufe nur noch interaktiv über `/sm-recherche`, der Skill trägt Lauf
  und Protokoll selbst ein
- 01.08.2026 abends: **Erster interaktiver Lauf erfolgreich** (Lauf 6) — 12 neue
  Beiträge (LinkedIn 8, Instagram 2, Facebook 2, Web 0). Damit ist bestätigt, dass
  die Chrome-Dienste über `/sm-recherche` wieder liefern und der Skill Lauf und
  Protokoll selbst einträgt. Projektordner verschoben von `Documents/GitHub/` nach
  `Documents/Claude/Projects/sm-archiv-board` — Git-Remote davon unberührt
- 02.08.2026: **Zustimmungs-Vorlage** für die Rechteinhaber erstellt (Word, im
  Vault; deckt auf Michaels Entscheidung Archiv-Board und Portal ab) — aufgesetzt
  auf dem offiziellen WBÖ-Briefbogen. Dazu **Corporate Design erschlossen**:
  Original in `Dropbox/_Ehrenamt/_WELTBUND/Bilder-Grafiken-Logos/_WBOE_Logo`
  (241 MB), Arbeitsauszug im Vault unter `Weltbund Österreich/Branding/
  Corporate-Design/` (36 Dateien, 9,4 MB, mit Manual und Word-Vorlagen);
  verbindlich sind Blau #007AC2, Rot #E52E0E, Hellblau #ACD4F3 und die Schriften
  Futura PT / Source Sans 3 mit Fallback Verdana / Calibri. Info dazu bei den
  KI-Mitarbeitern Brenda, Denise und Hans hinterlegt.
  **Facebook-Lücke geschlossen** — der Skill liest zusätzlich den `/videos`-Reiter,
  5 BMEIA-Videobeiträge nacherfasst; erfasst werden Vorschaubild, Text und Link,
  keine Videodateien (Beschluss Michael). Board-Hinweis entsprechend umformuliert
- 02.08.2026 (später): **Umzug des Boards auf Tiiny Host** — Michael hat das Repo auf
  privat gestellt, damit lieferte GitHub Pages nichts mehr aus; Cloudflare war ihm zu
  aufwendig. Neue Adresse `weltbund-archiv.tiiny.site` (Solo-Plan, öffentlich ohne
  Passwort — Zugriffsmodell unverändert). Folge für den Arbeitsablauf: Board-Änderungen
  brauchen jetzt einen Upload, ein Push allein bewirkt nichts

## Stillgelegt (nichts löschen)

- `SocialMedia/LinkedIn/Archiv-Board.html` (Vault): eingefroren, seit RLS-Abdichtung
  funktionslos — Nachfolger ist die Web-App
- `SocialMedia/LinkedIn/_erfasst.md`: historischer Auszug Stand 19.07.2026
- `archiv_server.py` (Port 8788): in `_Backup-2026-07-20/`

## Offene Punkte (Stand 01.08.2026)

- Erster Magic-Link-Login-Test durch Michael am Board: Link vom 31.07.2026
  (verschickt über den neuen SMTP an michael.schoepf@gmail.com) anklicken und
  prüfen, dass das Board lädt
- Erledigt 01.08.2026 (Lauf 6): Erster interaktiver Lauf durchgeführt — LinkedIn,
  Instagram und Facebook liefern über `/sm-recherche` wieder, der Skill trägt Lauf
  und Protokoll korrekt ein, der Board-Hinweis „Letzter Lauf … angefordert von …"
  erscheint. Bestand danach 81 Beiträge (LinkedIn 45, Instagram 8, Facebook 7,
  Web 21)
- Web-Bestand geprüft (Lauf 5, 01.08.2026): alle sechs Quellen abgefragt, 0 neue
  Beiträge — 21 Web-Posts sind vollständig (BMEIA 9, Weltniederösterreicher 7,
  Weltkärntner 3, Weltbund 1, Weltsteirer 1, Europa-Forum Wachau 0 mangels
  datierter Beiträge). BMEIA-Aktuelles ist JS-gerendert (curl allein reicht nicht)
- Erledigt 01.08.2026: Weltkärntner-Galerie vom 13.07. vollständig nachgeholt
  (40 Fotos in Vault, Storage und `sm_bilder`)
- Zustimmungs-Vorlage erstellt 02.08.2026: `Weltbund Österreich/
  Zustimmungserklaerung-Zweitverwertung-Vorlage.docx` (+ PDF), aufgesetzt auf
  dem **offiziellen WBÖ-Briefbogen**; deckt Archiv-Board UND Portal ab; Punkte:
  Nutzungsrechte, Fotos Dritter, Bildnisschutz, Quellennennung, unbefristet mit
  Widerruf, unentgeltlich; 4 Seiten, Hinweisblatt am Ende nicht mitversenden.
  OFFEN: Platzhalter füllen (Empfängerorganisation, Ansprechpartner mit
  Funktion), juristische Durchsicht, Versand an die sechs Organisationen,
  Rückläufe dokumentieren
- Facebook-Lücke 02.08.2026 weitgehend geschlossen: Video-/Reel-Beiträge werden
  jetzt über `/videos` erfasst, 5 BMEIA-Beiträge nachgeholt. Rest-Lücke: reine
  Textbeiträge ohne Bild und Video; bei Videos ist das Datum aus der relativen
  Altersangabe abgeleitet (im Vault-Eintrag als unverifiziert vermerkt). Der
  Board-Hinweis nennt seither beide Punkte
