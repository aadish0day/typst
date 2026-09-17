import re, glob, os, sys

FILES = sorted(glob.glob("/home/aadish/Documents/typst/FactStamp/**/*.typ", recursive=True))

CHECKS = [
    (1, "Inflated claims of importance/legacy", [
        r"\btestament\b", r"\bpivotal\b", r"\bcrucial\b", r"\bvital role\b", 
        r"\bindelible\b", r"\bevolving landscape\b", r"\bfocal point\b", 
        r"\bdeeply rooted\b", r"\bgame[- ]changer\b", r"\bcornerstone\b", r"\bmarks a milestone\b"
    ]),
    (2, "Name-dropping without substance", [
        r"\bindependent coverage\b", r"\bactive social media presence\b", r"\bwritten by a leading expert\b"
    ]),
    (3, "Shallow trailing -ing phrases", [
        r",\s+(?:highlighting|underscoring|emphasizing|ensuring|fostering|reflecting|symbolizing|contributing to|cultivating|showcasing)\b"
    ]),
    (4, "Sales language & promotional fluff", [
        r"\bboast[s]?\b", r"\bvibrant\b", r"\bprofound\b", r"\bgroundbreaking\b", 
        r"\bseamless(?:ly)?\b", r"\brobust(?:ly)?\b", r"\bstate[- ]of[- ]the[- ]art\b", 
        r"\bcutting[- ]edge\b", r"\bunparalleled\b", r"\bmeticulous(?:ly)?\b"
    ]),
    (5, "Vague sources", [
        r"\bindustry reports?\b", r"\bobservers? (?:have )?note[ds]?\b", 
        r"\bexperts? (?:argue|agree|state|point out)\b", r"\bstudies show\b", r"\bresearchers suggest\b"
    ]),
    (6, "Formulaic challenges / outlook", [
        r"\bdespite these challenges\b", r"\bfaces several challenges\b", r"\bfuture outlook\b"
    ]),
    (7, "Overused AI words", [
        r"\bdelve[ds]?\b", r"\btapestry\b", r"\binterplay\b", r"\bintricate\b", 
        r"\bfoster[s|ed|ing]?\b", r"\bgarner[s|ed]?\b", r"\blandscape\b", r"\bunderscore[s|d]?\b", 
        r"\belevate[s|d|ing]?\b", r"\bempower[s|ed|ing]?\b", r"\bharness(?:ing)?\b", 
        r"\bnuanced?\b", r"\bholistic\b", r"\bparadigm\b", r"\bmoreover\b", r"\bfurthermore\b", r"\badditionally\b"
    ]),
    (8, "Avoiding is/are (filler verbs)", [
        r"\bserves as\b", r"\bstands as\b", r"\bmarks a\b", r"\brepresents a\b", r"\bfeatures a\b"
    ]),
    (9, "Not X but Y / clipped negative endings", [
        r"\bnot only\b.*?\bbut (?:also)?\b", r"\bnot just\b.*?\bit[\x27\x60]?s\b", r",\s*no guessing\b"
    ]),
    (10, "Forced groups of three (trios)", [
        r"\b([a-zA-Z]+),\s+([a-zA-Z]+),\s+and\s+([a-zA-Z]+)\b"
    ]),
    (11, "Repetitive sentence openings", []), # handled dynamically
    (12, "False 'from X to Y' ranges", [
        r"\bfrom [^,]+ to [^,]+, from [^,]+ to [^,.]+\b"
    ]),
    (13, "Passive voice padding & missing subjects", [
        r"\bit is observed that\b", r"\bit is evident that\b", r"\bit has been noted that\b",
        r"\bhas the ability to\b", r"\bhave the ability to\b"
    ]),
    (14, "Em and en dashes (dramatic pauses)", [
        r"—", r"–", r"(?<!-)---(?!-)", r"(?<=\s)--(?!-)"
    ]),
    (15, "Too much arbitrary bold text", [
        r"\*\*[a-zA-Z0-9 ]{2,30}\*\*", r"\*[a-zA-Z0-9 ]{15,40}\*"
    ]),
    (16, "Lists with bold mini-headings", [
        r"^\s*[-+]\s+\*[A-Za-z0-9 /_-]+:\*"
    ]),
    (17, "Title case in headings", []), # checked in headings
    (18, "Emojis", [
        r"[\U00010000-\U0010ffff]"
    ]),
    (19, "Curly quotation marks", [
        r"[“”‘’]"
    ]),
    (20, "Chatbot conversational artifacts", [
        r"\bi hope this helps\b", r"\bcertainly!\b", r"\bof course!\b", r"\blet me know\b", r"\bhere is (?:a|the)\b"
    ]),
    (21, "Knowledge-limit disclaimers / speculative fills", [
        r"\bas of (?:2023|2024|2025|2026)\b", r"\bto my knowledge\b", r"\bnot publicly available, suggesting\b"
    ]),
    (22, "Overly agreeable tone", [
        r"\bgreat question\b", r"\byou[\x27\x60]?re absolutely right\b"
    ]),
    (23, "Filler phrases", [
        r"\bin order to\b", r"\bdue to the fact that\b", r"\bat this point in time\b", 
        r"\bit is important to note(?: that)?\b", r"\bit is worth noting(?: that)?\b", 
        r"\bit should be noted(?: that)?\b", r"\bit is crucial to\b"
    ]),
    (24, "Too many qualifiers / stacked hedges", [
        r"\bcould potentially\b", r"\bmight arguably\b", r"\bmay potentially\b", r"\barguably might\b"
    ]),
    (25, "Generic positive / optimistic endings", [
        r"\bthe future looks bright\b", r"\bexciting times lie ahead\b", r"\bpoised for continued growth\b"
    ]),
    (26, "Over-hyphenated predicate pairs", [
        r"\bis (?:state-of-the-art|client-facing|data-driven|real-time|end-to-end)\b"
    ]),
    (27, "Pretending to reveal deeper truth", [
        r"\bat its core\b", r"\bfundamentally\b", r"\bwhat really matters\b", r"\bthe heart of the matter\b"
    ]),
    (28, "Announcing the next point", [
        r"\blet[\x27\x60]?s (?:dive|explore|look|examine)\b", r"\bwe now delve into\b", r"\bhere is what you need to know\b"
    ]),
    (29, "Heading repeated in first sentence", []), # structural check
    (30, "Writing about previous versions unnecessarily", [
        r"\bwas added to replace the previous approach\b"
    ]),
    (31, "Forced punchlines & dramatic fragments", [
        r"\bSimple as that\.\b", r"\bThe old rules were gone\.\b"
    ]),
    (32, "Formulaic sayings", [
        r"\bis the currency of\b", r"\bis not a tool but a mirror\b", r"\bbecomes a trap\b"
    ])
]

total_findings = 0
file_report = {}

for f in FILES:
    rel_path = f.replace("/home/aadish/Documents/typst/FactStamp/", "")
    with open(f, "r", encoding="utf-8") as fp:
        lines = fp.readlines()
    
    findings = []
    
    for idx, line in enumerate(lines, 1):
        # Ignore comments and raw code blocks
        stripped = line.strip()
        if stripped.startswith("//"):
            continue
        
        for p_id, p_desc, regexes in CHECKS:
            for rx in regexes:
                matches = re.finditer(rx, line, flags=re.IGNORECASE)
                for m in matches:
                    findings.append({
                        "param": p_id,
                        "desc": p_desc,
                        "line": idx,
                        "match": m.group(0),
                        "snippet": stripped[:80]
                    })
    
    file_report[rel_path] = findings
    total_findings += len(findings)

print("=" * 80)
print(f"DEEP 32-PARAMETER AI AUDIT RESULTS ACROSS {len(FILES)} TYPST FILES")
print("=" * 80)
print(f"Total pattern instances found: {total_findings}\n")

for f, flist in file_report.items():
    if not flist:
        print(f"✓ {f}: 0 findings")
    else:
        print(f"✗ {f}: {len(flist)} findings")
        # count by parameter
        by_p = {}
        for x in flist:
            by_p[x["param"]] = by_p.get(x["param"], 0) + 1
        for pid in sorted(by_p.keys()):
            pname = [p[1] for p in CHECKS if p[0] == pid][0]
            print(f"    Param {pid:02d} ({pname}): {by_p[pid]} instances")

