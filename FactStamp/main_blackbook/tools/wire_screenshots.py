#!/usr/bin/env python3
"""Replace [SCREENSHOT: X (pending)] placeholders with the real captures.

Only rewrites a placeholder when its PNG actually exists in attachments/, so a
capture that failed keeps its visible "(pending)" marker instead of silently
turning into a broken #image() call that fails the Typst build.
"""
import re, sys
from pathlib import Path

CHAP = Path("06_Results_and_Discussion")
TYP = CHAP / "06_results_and_discussion.typ"
ATT = CHAP / "attachments"

LABEL_TO_FILE = {
    "Home": "home", "Sign In": "signin", "Sign Up": "signup",
    "Submit a Claim": "submit", "Claim Detail": "claim_detail",
    "Verify Queue": "verify_queue", "Verify Detail": "verify_detail",
    "Dashboard": "dashboard", "Profile": "profile",
    "Admin - System Overview": "admin_overview",
    "Admin - Verifier Directory": "admin_verifiers",
    "Admin - Claims Moderation": "admin_moderation",
    "Admin - Incident Queue": "admin_incidents",
    "Admin - Audit and Tools": "admin_audit",
}

def main() -> None:
    src = TYP.read_text(encoding="utf-8")
    wired, missing = [], []

    for label, stem in LABEL_TO_FILE.items():
        png = ATT / f"{stem}.png"
        old = f'#screenshot-placeholder("{label}")'
        if old not in src:
            print(f"  ?  placeholder not found for {label!r}")
            continue
        if not png.exists():
            missing.append(label)
            continue
        new = f'#responsive-image("attachments/{stem}.png", width: 92%)'
        src = src.replace(old, new)
        wired.append(label)

    TYP.write_text(src, encoding="utf-8")
    print(f"\n  wired {len(wired)}: {', '.join(wired) or '-'}")
    if missing:
        print(f"  left as pending {len(missing)}: {', '.join(missing)}")

if __name__ == "__main__":
    main()
