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
- **Anmeldung:** Magic Link (supabase-js, Version gepinnt mit SRI-Hash). Ohne Anmeldung
  nur die Login-Maske; nach Anmeldung prüft `rpc/sm_ist_nutzer` die Freischaltung
- **Funktionen:** Tabs Aktiv/Archiv/Papierkorb; Standardfilter "letzte 30 Tage"
  (abschaltbar); Detailansicht mit Volltext und Fotos (signierte URLs, 1 h gültig);
  globale Statuswechsel (archivieren/Papierkorb/wiederherstellen/endgültig löschen —
  Löschen entfernt DB-Zeile, Bildzeilen und Storage-Objekte, Vault-Dateien bleiben);
  **persönliche Markierungen je Nutzer**: "übernommen" (grüne Kennzeichnung) und
  "nicht interessant" (blendet für diesen Nutzer aus, über Filterhäkchen reversibel);
  **Nutzer einladen**: legt `sm_nutzer`-Eintrag an und verschickt den Anmeldelink

## Datenhaltung (Supabase-Projekt "my-bench")

- Ref `pysdixrqptnojwqymarb`, Organisation schoepf.consulting; URL + Publishable Key
  stehen in `index.html` und in `SocialMedia/LinkedIn/supabase-config.js` im Vault
- Tabellen: `sm_posts` (urn als Text: LinkedIn-URN-Zahl, Instagram-Shortcode oder
  `fb-<pfbid…>`; dienst, organisation, datum, titel, autor, text, post_url,
  reaktionen, kommentare, reposts, status erfasst/in_bearbeitung/archiviert/papierkorb,
  geloescht_am, vault_pfad), `sm_bilder` (urn, dateiname, storage_url, sort),
  `sm_nutzer` (email, name, aktiv, eingeladen_von), `sm_markierungen`
  (email, urn, markierung uebernommen|nicht_interessant)
- Storage-Bucket `sm-bilder`: **privat** (seit 31.07.2026), Zugriff über signierte URLs
- **RLS-Modell (31.07.2026):** anonym ist ALLES gesperrt (vorher waren die Tabellen
  inklusive Löschen anonym offen — behobenes Sicherheitsloch). Zugriff nur für
  angemeldete Nutzer, die aktiv in `sm_nutzer` stehen, geprüft über die
  security-definer-Funktion `sm_ist_nutzer()` (anon hat kein EXECUTE; Subselect auf die
  eigene Tabelle in der Policy würde "infinite recursion" auslösen — deshalb die Funktion).
  `sm_markierungen`: jeder nur die eigenen Zeilen
- **Auth-Konfiguration:** Site URL und Redirect URL stehen auf der Board-URL
  (gesetzt 31.07.2026 über Michaels Chrome; Supabase-Konsole gehört zum GitHub-Konto
  michaelschoepf62, Anmeldung GitHub-OAuth + TOTP durch Michael)
- Nutzerbestand: `michael@schoepf-consulting.com`, `michael.schoepf@gmail.com`
  (Redakteure) und `sm-automatik@schoepf-consulting.com` (Automatik, s. u.)

## Erfassung: Skill sm-recherche

- Global installiert: `~/.claude/skills/sm-recherche/SKILL.md` — wirkt in jedem Projekt
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

## Automatik (täglich 8:00)

- launchd-Job `com.schoepf.sm-recherche` (`~/Library/LaunchAgents/com.schoepf.sm-recherche.plist`)
  → `~/.config/sm-recherche/automatik.sh` → `claude -p "/sm-recherche automatik"
  --dangerously-skip-permissions`
- Automatik-Modus: keine Rückfragen, alle Dienste/Organisationen, 30 Tage, kein
  Board-Öffnen, Log nach `~/.config/sm-recherche/logs/JJJJ-MM-TT.log`
- Identität: `sm-automatik@schoepf-consulting.com` (Passwort-Login; per REST-Signup
  angelegt, E-Mail per SQL bestätigt, in `sm_nutzer` freigeschaltet)
- Voraussetzungen: Mac wach, Chrome offen mit gültigen LinkedIn/Instagram/Facebook-Logins
- Risiken (Michael bekannt, 31.07.2026): unbeaufsichtigte Browser-Automation ist
  fehleranfällig; tägliche automatisierte Abfrage verstößt formal gegen die
  Plattform-Nutzungsbedingungen (schlimmstenfalls Kontobeschränkung)

## Rechtlicher Rahmen Zweitverwertung (Einschätzung 31.07.2026, keine Rechtsberatung)

Übernahme ins Weltbund-Portal ist mit vorheriger Zustimmung der Rechteinhaber zulässig
(öUrhG, insb. § 18a Zurverfügungstellung). Absichern: (1) Zustimmung vom tatsächlichen
Rechteinhaber — Posts enthalten oft Fotos Dritter ("Foto: Rene Strasser",
"© Alexander Wieselthaler"), die Erklärung soll die Rechte an eingebetteten Fotos
mit abdecken; (2) Zustimmung schriftlich dokumentieren mit Umfang, Dauer, Widerruf;
(3) Quellen- und Urhebernennung plus Link zum Original; (4) bei erkennbaren Personen
Bildnisschutz (§ 78 öUrhG) und DSGVO beachten. Deshalb ist das Board bewusst
anmeldepflichtig: interne Arbeitskopie, keine öffentliche Zugänglichmachung.
[UNVERIFIZIERT: aktuelle Judikatur im Detail — vor der ersten Portal-Veröffentlichung
auf Wunsch nachrecherchieren.]

## Entscheidungshistorie (Kurzfassung)

- 19.07.2026: Erfassungsschema und Register etabliert (damals .md + `_erfasst.md`)
- 20.07.2026: Textdateien statt .md; Supabase (`sm_posts`/`sm_bilder`) wird führend;
  Archiv-Board als statische Datei ohne Server; Instagram und Facebook eingerichtet
- 26.07.2026: Register `_erfasst.md` stillgelegt (historischer Auszug, nichts löschen)
- 31.07.2026: 30-Tage-Umfang; Web-Board mit Anmeldepflicht + persönlichen Markierungen
  + Einladungsfunktion; RLS-Abdichtung (anonym gesperrt, Bucket privat);
  8-Uhr-Automatik; Auth-URLs gesetzt; Projekt aus KI-MITARBEITER herausgelöst

## Stillgelegt (nichts löschen)

- `SocialMedia/LinkedIn/Archiv-Board.html` (Vault): eingefroren, seit RLS-Abdichtung
  funktionslos — Nachfolger ist die Web-App
- `SocialMedia/LinkedIn/_erfasst.md`: historischer Auszug Stand 19.07.2026
- `archiv_server.py` (Port 8788): in `_Backup-2026-07-20/`

## Offene Punkte (Stand 31.07.2026)

- Erster Magic-Link-Login-Test durch Michael am Board (exakt eine der beiden
  Redakteursadressen verwenden)
- Ersten Automatik-Lauf prüfen: `~/.config/sm-recherche/logs/` (Folgetag nach 8:00)
- Zustimmungs-Vorlage für die Rechteinhaber erstellen (vor erster Portal-Übernahme)
- Facebook-Lücke: Video-/Reel-Posts ohne Foto werden nicht erfasst
- X (Twitter) ist als Dienst vorgesehen, aber nicht eingerichtet
