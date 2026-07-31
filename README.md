# SocialMedia Archiv-Board (Weltbund Österreich)

Internes Arbeitswerkzeug: erfasste Social-Media-Beiträge der Weltbund-Organisationen
und des BMEIA sichten, markieren und für die Zweitverwertung vorbereiten.

- **Zugang nur nach Anmeldung** (Magic Link); Nutzerverwaltung über Einladungen
  bestehender Nutzer. Row Level Security: ohne Eintrag in `sm_nutzer` keine Daten
- **Daten:** Supabase-Projekt "my-bench" (`sm_posts`, `sm_bilder`, `sm_nutzer`,
  `sm_markierungen`); Fotos in privatem Storage-Bucket (signierte URLs)
- **Persönliche Markierungen** je Nutzer: "übernommen" und "nicht interessant"
  (Letzteres blendet den Beitrag für diesen Nutzer aus)
- **Standardansicht:** Beiträge der letzten 30 Tage
- Erfassung der Beiträge: Skill `sm-recherche` (täglicher Lauf 8:00 auf Michaels Mac)

Hinweis Urheberrecht: Inhalte Dritter — nur intern nutzen. Veröffentlichung im
Weltbund-Portal ausschliesslich nach dokumentierter Zustimmung der Rechteinhaber.
