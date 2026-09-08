// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "blackbook") == "blackbook"



// Cross-Platform Font Fallbacks (Windows/Mac/Linux CI compatibility)
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 12pt,
  lang: "en",
  hyphenate: true, // Prevents text clipping in narrow table cells
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt) // Mandatory Justified Content (12pt Times New Roman)
#set heading(numbering: "1.1")

// Heading Styling Rules: Heading 16pt bold, Subheadings 14pt bold
#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory Rule: New topic / major section on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

// Global Table Cell Styling
#show table.cell: set text(size: 10pt)
#show table.cell.where(y: 0): set text(size: 10pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Raw Code Block Styling
#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.4pt + luma(180),
  inset: 8pt,
  radius: 2pt,
  width: 100%,
  text(
    font: ("Fira Code", "DejaVu Sans Mono", "Courier New"),
    size: 9.5pt,
    it
  )
)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

// Responsive Image Helper (Typst 0.15+ compatible)
#let responsive-image(path, width: 90%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

// ==========================================
// Standalone-Mode Title Header Block
// ==========================================
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[References]
    #v(4pt)
    #text(size: 13pt, style: "italic")[FactStamp --- A Community-Powered WhatsApp Misinformation Fact-Checker]
    #v(10pt)
    #text(size: 10.5pt)[Course: Project Dissertation and Implementation (`JUSIT-DSCPR503`) --- BSc Information Technology, Semester V]\
    #text(size: 10.5pt)[Student: Aadish Das #sym.dot.c Guides: Mr. Wilson Rao (HOD) #sym.amp Ms. Bertilla Fernandes]\
    #text(size: 10.5pt)[Jai Hind College (Empowered Autonomous), Mumbai --- 2026-27]
  ]
  #v(20pt)
]

// ==========================================
// References (Unnumbered Back-Matter Section)
// ==========================================
#heading(numbering: none)[References]

+ IEEE Computer Society, *"IEEE Recommended Practice for Software Requirements Specifications,"* IEEE Std 830-1998, 1998.
+ Schwaber, K., & Sutherland, J., *"The Scrum Guide: The Definitive Guide to Scrum: The Rules of the Game,"* Scrum.org, Nov. 2020.
+ Vosoughi, S., Roy, D., & Aral, S., *"The spread of true and false news online,"* _Science_, vol. 359, no. 6380, pp. 1146-1151, 2018.
+ Garimella, K., & Eckles, D., *"Images and misinformation in political groups: Evidence from WhatsApp in India,"* _Harvard Kennedy School (HKS) Misinformation Review_, vol. 1, Aug. 2020. doi: 10.37016/mr-2020-030.
+ Jaccard, P., *"Étude comparative de la distribution florale dans une portion des Alpes et des Jura,"* _Bulletin de la Société Vaudoise des Sciences Naturelles_, vol. 37, pp. 547-579, 1901.
+ OWASP Foundation, *"OWASP Top Ten,"* Open Worldwide Application Security Project, 2021. [Online]. Available: `https://owasp.org/www-project-top-ten/`.
+ Meta Platforms, Inc., *"React --- The Library for Web and Native User Interfaces,"* React Documentation, 2025. [Online]. Available: `https://react.dev/`.
+ Evan You & Vite Contributors, *"Vite --- Next Generation Frontend Tooling,"* Vite Documentation, 2025. [Online]. Available: `https://vite.dev/`.
+ Microsoft Corporation, *"TypeScript --- JavaScript With Syntax for Types,"* TypeScript Documentation, 2025. [Online]. Available: `https://www.typescriptlang.org/docs/`.
+ Tailwind Labs Inc., *"Tailwind CSS v4 Documentation,"* 2025. [Online]. Available: `https://tailwindcss.com/docs`.
+ World Wide Web Consortium (W3C), *"CSS Color Module Level 4 (OKLCH / OKLAB Color Spaces),"* W3C Candidate Recommendation Draft, 2026. [Online]. Available: `https://www.w3.org/TR/css-color-4/`.
+ Google LLC, *"Cloud Firestore Documentation --- Data Model, Security Rules & Realtime Snapshot Listeners,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/firestore`.
+ Google LLC, *"Firebase Authentication Documentation,"* Firebase Documentation, 2025. [Online]. Available: `https://firebase.google.com/docs/auth`.
+ Remix Software, Inc., *"React Router Documentation,"* 2025. [Online]. Available: `https://reactrouter.com/`.
+ Recharts Group, *"Recharts --- A Composable Charting Library Built on React Components,"* 2025. [Online]. Available: `https://recharts.org/`.
+ Project Naptha and Tesseract.js Contributors, *"Tesseract.js --- Pure JavaScript OCR for 100 Languages,"* Open-Source Software Documentation, 2025. [Online]. Available: `https://tesseract.projectnaptha.com/`.
+ Bubkoo, *"html-to-image: Generates images from HTML nodes using SVG and Canvas,"* Open-Source Software Specification, 2024. [Online]. Available: `https://github.com/bubkoo/html-to-image`.

#v(8pt)
