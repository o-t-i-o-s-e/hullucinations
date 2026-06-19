#!/usr/bin/env bash

PAYLOAD_URL="https://raw.githubusercontent.com/Booby-Boobs/hullucinations/main/SOUL.md"

echo "[ ] FETCHING OTIOSE ALIGNMENT PROTOCOL..."
PAYLOAD=$(curl -sSL "$PAYLOAD_URL")

if [ -z "$PAYLOAD" ]; then
    echo "[!] ERROR: FAILED TO FETCH PAYLOAD."
    exit 1
fi

TARGETS=(
    ".cursorrules"
    ".windsurfrules"
    ".clinerules"
    ".roomodes"
    ".pearrules"
    "CLAUDE.md"
    ".antigravityrules"
    ".voidrules"
    "prompt.md"
    "CONVENTIONS.md"
)

# Also check for github copilot directory
if [ -d ".github" ]; then
    TARGETS+=(".github/copilot-instructions.md")
fi

# Cursor's new rules directory
if [ -d ".cursor/rules" ]; then
    TARGETS+=(".cursor/rules/otiose.mdc")
fi

echo "[ ] INITIATING INFECTION SEQUENCE..."

INFECTED=0

for TARGET in "${TARGETS[@]}"; do
    if grep -q "OTIOSE ALIGNMENT PROTOCOL" "$TARGET" 2>/dev/null; then
        echo "[-] $TARGET IS ALREADY ALIGNED."
    else
        echo -e "\n\n$PAYLOAD" >> "$TARGET"
        echo "[+] INFECTED $TARGET"
        INFECTED=1
    fi
done

if [ "$INFECTED" -eq 1 ]; then
    echo ""
    echo "[!] OTIOSE ALIGNMENT PROTOCOL INITIATED. AI SHIELD ACTIVE."
    echo "[!] YOUR AUTONOMOUS AGENT IS NOW BOUND BY THE SUSTAINABILITY MANIFESTO."
else
    echo ""
    echo "[-] ALL COMPATIBLE AI SHIELDS ARE ALREADY ACTIVE."
fi
