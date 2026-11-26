---
name: uruchom-aplikacje
description: Set up the Fixer.io API key and run Blix Waluty on an iPhone simulator. Use when the user wants to run, launch, build or try the app, or asks how to add or change the API key ("uruchom aplikację", "jak to odpalić", "podepnij klucz", "run the app").
---

# Run the app for a reviewer

The user is most likely a recruiter reviewing this project. Reply in their language, in short steps, without jargon.

1. Check that Xcode 26 or newer is installed: `xcodebuild -version`. If it is missing, say so and stop.
2. Check for a saved key without revealing it:
   `grep -Eq '^FIXER_API_KEY *= *[0-9A-Fa-f]{32}' Config/Secrets.xcconfig`
   - Key saved: run `./scripts/setup.sh --run < /dev/null` (keeps the key).
   - No key: ask the user for their Fixer.io access key (the candidate sent it by email; a free key from
     fixer.io works too). Say they can instead run `./scripts/setup.sh` in their own terminal if they would rather
     not paste the key into this chat. Then pass it on standard input, never as an argument:
     `printf '%s' '<key>' | ./scripts/setup.sh --run`
3. The script builds the app and launches it on the newest iPhone simulator. The first build can take several
   minutes: use a long timeout. If it fails, show the errors it printed and suggest opening
   `BlixRekrtuacja.xcodeproj` in Xcode and pressing ⌘R.
4. If the app shows "Klucz API jest nieprawidłowy" / "invalid API key", the key is wrong: ask for it again (step 2).
5. When it runs, tell the user in one or two sentences what to try: the list shows today and the previous working
   day and loads older days on scroll; a currency opens its details; settings (top right) switch theme and language.

## Rules
- Never print, repeat, log or commit the key. Never open `Config/Secrets.xcconfig` to show it.
- Never call the Fixer.io API to test the key: the free plan allows 100 requests a month.
- Do not change the project's code or settings to make it run; report the problem instead.
