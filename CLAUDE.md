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
  - KIARCH/kiarch: Board öffnen — `open "https://michaelschoepf62.github.io/sm-archiv-board/"`
  - KIRECHERCHE/kirecherche bzw. SM-RECHERCHE: Skill `sm-recherche` ausführen

## Die Web-App

- **Live:** https://michaelschoepf62.github.io/sm-archiv-board/ (GitHub Pages, Branch main,
  Root; Push auf main = Deployment)
- **Repo:** `michaelschoepf62/sm-archiv-board` (public), lokal
  `/Users/michaelschopf/Documents/GitHub/sm-archiv-board/`; eine einzelne `index.html`
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
  **manueller Aktualisierungslauf** (Knopf „🔄 Aktualisieren", alle aktiven Nutzer):
  legt eine Anforderung in `sm_laeufe` an und zeigt mittig ein Fortschritts-Overlay
  (wartet/echte Prozente je Organisation/fertig); Schutzbremse: nur ein offener Lauf
  (Unique-Index) und frühestens 60 Minuten nach dem letzten fertigen Lauf

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
- **Auth-Konfiguration:** Site URL und Redirect URL stehen auf der Board-URL
  (gesetzt 31.07.2026 über Michaels Chrome; Supabase-Konsole gehört zum GitHub-Konto
  michaelschoepf62, Anmeldung GitHub-OAuth + TOTP durch Michael)
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
  og:image-Trick), Facebook (Foto-Seiten, pfbid-Permalink; Videos ohne Foto werden
  NICHT gefunden — bekannte Lücke)
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

## Manuelle Läufe vom Board (seit 31.07.2026)

- launchd-Job `com.schoepf.sm-lauf-watcher` (jede Minute; RunAtLoad) →
  `~/.config/sm-recherche/lauf-watcher.sh`: prüft `sm_laeufe` auf Anforderungen,
  setzt Cooldown durch (60 min nach letztem fertigen Lauf → `fehler`), markiert
  `laeuft` und startet `claude -p "/sm-recherche automatik"`; nach Skript-Ende
  `fertig` (100 %) bzw. `fehler`. Log: `~/.config/sm-recherche/logs/JJJJ-MM-TT_laeufe.log`
- Der Skill meldet im Automatik-Modus den Fortschritt je (Dienst, Organisation)
  nach `sm_laeufe` (max. 99 %), wenn ein Lauf mit Status `laeuft` existiert
- Läuft nur, wenn der Mac wach und Chrome mit gültigen Logins offen ist — sonst
  bleibt die Anforderung stehen (Board zeigt „Wartet auf den Arbeitsrechner")
- Bricht der Skill sauber ab, setzt er die Zeile selbst auf `fehler` (sonst
  meldete der Watcher fälschlich „fertig" — Lehre aus Testlauf 4, 31.07.2026);
  der Watcher schließt nur noch Zeilen ab, die noch auf `laeuft` stehen

## Keine tägliche Automatik mehr (Beschluss Michael 01.08.2026)

- Der 8-Uhr-Job `com.schoepf.sm-recherche` ist ABGESCHALTET und die Plist gelöscht;
  `~/.config/sm-recherche/automatik.sh` bleibt als Datei liegen (unbenutzt)
- Läufe starten AUSSCHLIESSLICH Redakteure über den Board-Knopf „🔄 Aktualisieren"
- Der Automatik-Modus des Skills und die Identität
  `sm-automatik@schoepf-consulting.com` (Passwort-Login, in `sm_nutzer`
  freigeschaltet) bleiben — der Watcher nutzt beides für die manuellen Läufe
- Voraussetzung: Mac wach; für die Chrome-Dienste zusätzlich Chrome mit gültigen
  Logins (siehe offener Punkt kopfloser Chrome-Zugriff)

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

## Stillgelegt (nichts löschen)

- `SocialMedia/LinkedIn/Archiv-Board.html` (Vault): eingefroren, seit RLS-Abdichtung
  funktionslos — Nachfolger ist die Web-App
- `SocialMedia/LinkedIn/_erfasst.md`: historischer Auszug Stand 19.07.2026
- `archiv_server.py` (Port 8788): in `_Backup-2026-07-20/`

## Offene Punkte (Stand 31.07.2026)

- Erster Magic-Link-Login-Test durch Michael am Board: Link vom 31.07.2026
  (verschickt über den neuen SMTP an michael.schoepf@gmail.com) anklicken und
  prüfen, dass das Board lädt
- Erster Automatik-Lauf (01.08.2026, 8:00) TEILERFOLG: Dienst Web voll funktionsfähig
  (21 Web-Beiträge + 24 Fotos erfasst, dual in Vault und DB); die Chrome-Dienste
  (LinkedIn/Instagram/Facebook) bekamen auch kopflos KEINE Verbindung zur
  Claude-in-Chrome-Extension. Entscheidung Michael offen: `automatik.sh` startet
  Chrome mit `--remote-debugging-port=9222` (plus Skill-Umstellung auf CDP) oder
  Playwright-Profil — bis dahin erfassen Automatik/Board-Läufe nur den Dienst Web
- Erledigt 01.08.2026: Weltkärntner-Galerie vom 13.07. vollständig nachgeholt
  (40 Fotos in Vault, Storage und `sm_bilder`)
- Zustimmungs-Vorlage für die Rechteinhaber erstellen — seit der öffentlichen
  Lesesicht doppelt wichtig (schriftliche Dokumentation der laut Michael erteilten
  Zustimmungen)
- Ersten Web-Lauf prüfen (Dienst „Web", sechs Quellen — kommt mit dem nächsten
  Automatik- oder Board-Lauf)
- Facebook-Lücke: Video-/Reel-Posts ohne Foto werden nicht erfasst (Dauerhinweis
  dazu steht seit 31.07.2026 im Board)
