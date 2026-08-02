#!/bin/bash
# Rollt index.html auf Tiiny Host aus (weltbund-archiv.tiiny.site).
#
# Seit dem Umzug am 02.08.2026 ist ein Push auf main KEIN Deployment mehr —
# das Board wird ueber diese API aktualisiert. Zugangsdaten liegen in
# ~/.config/tiiny-host/api.json (nicht im Repo).
#
# Aufruf:  ./deploy.sh

set -euo pipefail

CONF="$HOME/.config/tiiny-host/api.json"
DATEI="$(dirname "$0")/index.html"

[ -f "$CONF" ]  || { echo "FEHLER: $CONF fehlt (api_key und domain)."; exit 1; }
[ -f "$DATEI" ] || { echo "FEHLER: index.html nicht gefunden."; exit 1; }

KEY=$(python3 -c "import json;print(json.load(open('$CONF'))['api_key'])")
DOMAIN=$(python3 -c "import json;print(json.load(open('$CONF'))['domain'])")

echo "Rolle $(basename "$DATEI") aus nach $DOMAIN ..."

# disableIndexing: Das Board bleibt oeffentlich erreichbar, wird aber nicht von
# Suchmaschinen erfasst (Beschluss Michael 02.08.2026 — die schriftlichen
# Zustimmungen der Rechteinhaber stehen noch aus).
ANTWORT=$(curl -s --max-time 120 -X PUT "https://ext.tiiny.host/v1/upload" \
  -H "x-api-key: $KEY" \
  -F "files=@$DATEI" \
  -F "domain=$DOMAIN" \
  -F 'siteSettings={"disableIndexing": true}')

python3 - "$ANTWORT" <<'PY'
import json, sys
try:
    d = json.loads(sys.argv[1])
except Exception:
    print("FEHLER: unerwartete Antwort:", sys.argv[1][:300]); sys.exit(1)
if not d.get("success"):
    print("FEHLGESCHLAGEN:", json.dumps(d)[:300]); sys.exit(1)
data = d.get("data", {})
print(f"  ok — https://{data.get('link','?')} ({data.get('status','?')})")
p = data.get("profile", {})
if p:
    print(f"  Speicher: {p.get('quotaUsed','?')} von {p.get('quotaLimit','?')}")
PY
