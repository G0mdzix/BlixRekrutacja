#!/bin/bash
# Wpina klucz Fixer.io do aplikacji Blix Waluty i opcjonalnie uruchamia ją na symulatorze iPhone'a.
#
#   ./scripts/setup.sh                     pyta o klucz, potem proponuje uruchomienie
#   ./scripts/setup.sh --run               to samo, od razu buduje i uruchamia
#   printf '%s' KLUCZ | ./scripts/setup.sh --run    klucz z wejścia (np. z Claude Code)
#   ./scripts/setup.sh --run < /dev/null   zostawia zapisany klucz i uruchamia
#
# Klucz trafia tylko do Config/Secrets.xcconfig, który git ignoruje. Skrypt nie wysyła żadnych zapytań do Fixer.io.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SECRETS="$ROOT/Config/Secrets.xcconfig"
PROJECT="$ROOT/BlixRekrtuacja.xcodeproj"
SCHEME="BuildApp"
BUNDLE_ID="MateuszGozdzik.BlixRekrutacja.BlixRekrtuacja"
DERIVED="${TMPDIR:-/tmp}/BlixWaluty-build"
KEY_PATTERN='^[0-9A-Fa-f]{32}$'
KEY_LENGTH=32
VISIBLE_KEY_CHARS=4

fail() { echo "❌ $*" >&2; exit 1; }

saved_key() {
    [ -f "$SECRETS" ] || return 0
    sed -nE 's/^[[:space:]]*FIXER_API_KEY[[:space:]]*=[[:space:]]*([^[:space:]]*).*/\1/p' "$SECRETS" | tail -n 1
}

masked() { echo "…${1:$((KEY_LENGTH - VISIBLE_KEY_CHARS))}"; }

read_key() {
    local current key
    current="$(saved_key)"
    if [ -t 0 ]; then
        echo "Blix Waluty potrzebuje klucza API Fixer.io (32 znaki). Darmowy klucz założysz na"
        echo "https://fixer.io: Get Free API Key, plan Free, a potem skopiuj API Access Key z panelu."
        [ -n "$current" ] && echo "Zapisany klucz: $(masked "$current"). Enter zostawia go bez zmian."
        read -r -s -p "Wklej klucz: " key
        echo
    else
        key="$(cat)"
    fi
    key="$(printf '%s' "$key" | tr -d '[:space:]')"
    if [ -z "$key" ]; then
        [ -n "$current" ] || fail "Nie podano klucza."
        KEY="$current"
        echo "✔︎ Zostawiam zapisany klucz $(masked "$KEY")."
        return
    fi
    [[ "$key" =~ $KEY_PATTERN ]] || fail "To nie wygląda na klucz Fixer.io: powinien mieć 32 znaki 0–9 i a–f. Nic nie zapisałem."
    KEY="$key"
    save_key
}

save_key() {
    local replaced=""
    [ -f "$SECRETS" ] && replaced=" (zastąpił poprzedni)"
    (
        umask 077
        printf '// Utworzone przez scripts/setup.sh. Git ignoruje ten plik.\nFIXER_API_KEY = %s\n' "$KEY" > "$SECRETS"
    )
    chmod 600 "$SECRETS"
    echo "✔︎ Zapisałem klucz $(masked "$KEY") w Config/Secrets.xcconfig$replaced."
    if git -C "$ROOT" rev-parse --is-inside-work-tree > /dev/null 2>&1 && ! git -C "$ROOT" check-ignore -q "$SECRETS"; then
        echo "⚠️  Git nie ignoruje Config/Secrets.xcconfig. Nie commituj tego pliku." >&2
    fi
}

pick_simulator() {
    local booted
    booted="$(xcrun simctl list devices available | grep -E '^ +iPhone.*\(Booted\)' | head -n 1 || true)"
    if [ -n "$booted" ]; then
        echo "$booted"
        return
    fi
    # The newest iOS runtime is listed last; take its first iPhone.
    xcrun simctl list devices available | awk '
        /^-- / { ios = ($2 == "iOS"); first = 1; next }
        ios && /^ +iPhone/ && first { candidate = $0; first = 0 }
        END { print candidate }'
}

run_app() {
    command -v xcodebuild > /dev/null || fail "Brak Xcode. Zainstaluj Xcode 26 lub nowszy z App Store."
    local device udid name log app
    device="$(pick_simulator)"
    [ -n "$device" ] || fail "Nie znalazłem symulatora iPhone'a. Dodaj go w Xcode: Window → Devices and Simulators."
    udid="$(echo "$device" | grep -oE '[0-9A-F]{8}(-[0-9A-F]{4}){3}-[0-9A-F]{12}')"
    name="$(echo "$device" | sed -E 's/^ +//; s/ \(.*//')"

    echo "⏳ Buduję aplikację na $name (pierwszy raz może to potrwać kilka minut)…"
    log="$DERIVED/build.log"
    mkdir -p "$DERIVED"
    if ! xcodebuild -project "$PROJECT" -scheme "$SCHEME" -destination "id=$udid" \
        -derivedDataPath "$DERIVED" build > "$log" 2>&1; then
        grep -E 'error:' "$log" | head -n 10 >&2 || true
        fail "Budowanie się nie udało. Pełny log: $log. Możesz też otworzyć projekt w Xcode i nacisnąć ⌘R."
    fi

    app="$DERIVED/Build/Products/Debug-iphonesimulator/BlixRekrtuacja.app"
    echo "⏳ Uruchamiam symulator i aplikację…"
    xcrun simctl boot "$udid" 2> /dev/null || true
    open -a Simulator
    xcrun simctl bootstatus "$udid" -b > /dev/null
    xcrun simctl install "$udid" "$app"
    xcrun simctl launch "$udid" "$BUNDLE_ID" > /dev/null
    echo "✅ Blix Waluty działa na symulatorze $name."
}

RUN=false
case "${1:-}" in
    --run) RUN=true ;;
    "") ;;
    -h | --help) awk 'NR > 1 && /^#/ { sub(/^# ?/, ""); print; next } NR > 1 { exit }' "$0"; exit 0 ;;
    *) fail "Nieznana opcja: $1 (użyj --run albo --help)." ;;
esac

KEY=""
read_key

if ! $RUN && [ -t 0 ]; then
    read -r -p "Zbudować i uruchomić aplikację na symulatorze? [T/n] " answer
    case "$answer" in [nN]*) ;; *) RUN=true ;; esac
fi

if $RUN; then
    run_app
else
    echo "Gotowe. Otwórz BlixRekrtuacja.xcodeproj w Xcode i naciśnij ⌘R (albo uruchom: ./scripts/setup.sh --run)."
fi
