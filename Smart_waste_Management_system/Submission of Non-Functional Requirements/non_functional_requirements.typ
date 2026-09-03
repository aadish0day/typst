// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set document(
  title: "Smart Waste Management System - Non-Functional Requirements Specification",
  author: "Aadish Das (Roll No: 10, UID: 24BIT010)",
)

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border for Black Books and Assignments
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  ),
)

// Cross-Platform Font Fallbacks
#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

// Global Table Cell Styling
#show table.cell: set text(size: 10pt)
#show table.cell.where(y: 0): set text(size: 10pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

// Reusable Academic Table Helper
#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + black, bottom: 1.2pt + black) } else { 0.4pt + luma(180) },
  fill: (x, y) => if y == 0 { rgb("F0F0F0") } else if calc.even(y) { rgb("FAFAFA") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 10pt, weight: "bold")[#h]])),
  ..rows.pos().map(cell => text(size: 10pt)[#cell])
)

// Responsive Image Helper
#let responsive-image(path, width: 100%, max-height: none) = align(center)[
  #if max-height == none [
    #image(path, width: width)
  ] else [
    #image(path, width: width, height: max-height, fit: "contain")
  ]
]

// Dual-Mode Title Header
#if not is-assembly [
  #align(center)[
    #text(size: 18pt, weight: "bold")[Smart Waste Management System]
    #v(4pt)
    #text(size: 12pt, weight: "medium")[IoT-Enabled & Community-Integrated Urban Waste Optimization Platform]
    #v(10pt)
    #text(size: 12pt, style: "italic")[Submission: Non-Functional Requirements (NFR) Engineering Specification]
    #v(14pt)
    #block(
      stroke: 0.5pt + luma(180),
      fill: rgb("FAFAFA"),
      inset: 10pt,
      radius: 4pt,
      width: 85%,
      align(left)[
        #grid(
          columns: (auto, 1fr),
          row-gutter: 0.5em,
          column-gutter: 1.2em,
          [*Student Name:*], [Aadish Das],
          [*Roll No:*], [10],
          [*UID:*], [24BIT010],
          [*Subject:*], [ASDT],
          [*Department:*], [Department of Information Technology],
          [*Institution:*], [Jai Hind College, Mumbai],
        )
      ]
    )
  ]
  #v(16pt)
]

// Mandatory TOC Placement Rule: Outline on its own dedicated page
#pagebreak()
#align(center)[
  #text(size: 14pt, weight: "bold")[Table of Contents]
]
#v(0.8em)
#outline(title: none, indent: 1.5em, depth: 3)
#pagebreak()

== Document Revision History

#styled-table(
  columns: (1fr, 1.2fr, 2.5fr, 1fr),
  headers: ("Version", "Date", "Reason For Changes", "Author"),
  "1.0.0", "2026-08-27", "Initial baseline Non-Functional Requirements specification for Smart Waste Management System.", "Aadish Das (24BIT010)",
  "1.1.0", "2026-08-27", "Added quantitative verification matrices, security architecture diagrams, and SLA benchmarks.", "Aadish Das (24BIT010)",
)

#v(1em)

= Executive Overview of Non-Functional Requirements (NFRs)

== Scope & Purpose
This document establishes the formal engineering specification for all *Non-Functional Requirements (NFRs)* governing the *Smart Waste Management System (SWMS)*. While functional requirements define *what* the system does, non-functional requirements define *how well* the system performs under operational, environmental, and security constraints.

Defining explicit, measurable, and verifiable NFRs is critical for an IoT-enabled urban platform operating across thousands of physical containers and mobile field units. These requirements guide system architecture decisions, cloud infrastructure sizing, edge hardware selection, and automated testing frameworks.

== System Quality Attributes Taxonomy
The non-functional requirements for the Smart Waste Management System are categorized into six core quality attribute domains:

#responsive-image("attachments/nfr_quality_tree.svg", width: 100%)

== NFR Evaluation & Priority Matrix
Each non-functional requirement is assigned a priority rating based on operational criticality:
- *Critical (P1):* Failure to satisfy invalidates system deployment or creates safety hazards (e.g., immediate hazard alert latency, data encryption).
- *High (P2):* Essential for system performance and user satisfaction (e.g., API latency, 99.95% uptime SLA).
- *Medium (P3):* Desirable quality attributes that enhance efficiency and maintainability (e.g., code coverage, automated reporting).

#pagebreak(weak: true)

= Performance, Scalability & Throughput Requirements

== Latency Benchmarks
The system must meet strict latency targets across web APIs, mobile clients, and IoT telemetry ingestion pipelines under normal and peak loads:

#styled-table(
  columns: (1.8fr, 1fr, 1fr, 1.2fr),
  headers: ("Operation / API Endpoint", "P95 Latency Target", "P99 Latency Target", "Priority Level"),
  "IoT Telemetry Ingestion (MQTT Publish)", "< 50 ms", "< 100 ms", "Critical (P1)",
  "Real-Time Bin Status Map API", "< 120 ms", "< 250 ms", "High (P2)",
  "Dynamic Route Calculation Engine", "< 1.5 seconds", "< 3.0 seconds", "High (P2)",
  "Citizen Incident Photo Upload & AI Tagging", "< 2.0 seconds", "< 4.0 seconds", "Medium (P3)",
  "Executive Dashboard Analytics Aggregation", "< 800 ms", "< 1.8 seconds", "Medium (P3)"
)

== Telemetry Throughput & Peak Capacity
1. *NFR-PERF-1.1 [Ingestion Throughput]:* The MQTT broker cluster shall process a steady-state stream of 10,000 sensor telemetry messages per minute (166 messages/second) with zero message loss.
2. *NFR-PERF-1.2 [Burst Load Capacity]:* During emergency events (e.g., post-storm municipal cleanup), the system infrastructure shall auto-scale to absorb peak bursts of up to 50,000 messages/second for up to 30 minutes.
3. *NFR-PERF-1.3 [Connection Concurrency]:* The gateway tier shall maintain up to 25,000 persistent, active MQTT connections from smart bin nodes simultaneously.

== Spatial GIS Indexing & Search Speed
1. *NFR-PERF-2.1 [Spatial Query Latency]:* Geospatial proximity searches querying nearest available bins or incident reports within a 10 km radius shall execute in under 25 ms using spatial indexing.
2. *NFR-PERF-2.2 [Polyline Route Generation]:* Sequential waypoint polyline calculations for a truck route containing up to 50 collection stops shall complete in under 1.2 seconds.

== Client Application Responsiveness (Core Web Vitals)
1. *NFR-PERF-3.1 [Web Dashboard Load Speed]:* The municipal web dashboard shall achieve a First Contentful Paint (FCP) under 1.0 second and a Time to Interactive (TTI) under 2.0 seconds on standard broadband connections.
2. *NFR-PERF-3.2 [Mobile UI Frame Rate]:* The driver tablet and citizen mobile applications shall maintain a smooth rendering frame rate of at least 58 FPS during map panning and list scrolling.

#pagebreak(weak: true)

= Reliability, Availability & Fault Tolerance

== Availability SLA & Operational Metrics
1. *NFR-REL-1.1 [Service Availability SLA]:* The core cloud infrastructure shall maintain a minimum service uptime of 99.95%, permitting no more than 4.38 hours of unplanned downtime per calendar year.
2. *NFR-REL-1.2 [MTBF & MTTR Metrics]:* The system shall demonstrate a Mean Time Between Failures (MTBF) of at least 720 hours and a Mean Time To Recovery (MTTR) under 15 minutes for automated cloud failovers.

#styled-table(
  columns: (1.5fr, 1.2fr, 2.3fr),
  headers: ("Reliability Metric", "Target Threshold", "Operational Meaning & Enforcement"),
  "System Availability SLA", "99.95% Uptime", "Enforced via multi-region Kubernetes cluster deployment and active health probes.",
  "MTBF (Mean Time Between Failures)", ">= 720 Hours", "Measures core microservice stability under continuous load.",
  "MTTR (Mean Time To Recovery)", "< 15 Minutes", "Automated container pod restarting and database primary node failover.",
  "RPO (Recovery Point Objective)", "< 1.0 Minute", "Maximum permissible data loss duration during a catastrophic disaster.",
  "RTO (Recovery Time Objective)", "< 30 Minutes", "Maximum allowable time to fully restore operational capabilities after disaster."
)

== Offline Store-and-Forward Sync Mechanism
1. *NFR-REL-2.1 [Driver Mobile Offline Mode]:* The driver tablet application shall operate seamlessly without internet connectivity, storing route completion logs and waypoint updates in an encrypted local SQLite database.
2. *NFR-REL-2.2 [Automatic Synchronization]:* Upon detecting restored cellular connectivity (4G/5G), the mobile app shall execute a background delta-sync protocol transferring queued logs in under 10 seconds.
3. *NFR-REL-2.3 [Edge Gateway Telemetry Buffering]:* Physical IoT edge gateways shall store sensor telemetry payloads locally for up to 72 hours during cellular network partitions, resuming transmission automatically once reconnected.

== Redundancy, Failover & Database Replication
1. *NFR-REL-3.1 [Database Primary-Replica Failover]:* The primary database cluster shall maintain active cross-zone synchronous replication. Automated failover to a standby node shall complete within 30 seconds if the primary node degrades.
2. *NFR-REL-3.2 [Stateless Microservices]:* All backend API microservices shall remain strictly stateless to enable instant instance termination and replacement without session loss.

#pagebreak(weak: true)

= Security, Data Protection & Privacy Requirements

== Security & Encryption Architecture
The system enforces strict zero-trust security standards across hardware telemetry, network transport, user authentication, and persistent data storage.

#responsive-image("attachments/security_architecture.svg", width: 100%)

== Transport Security
1. *NFR-SEC-1.1 [TLS 1.3 Mandatory Encryption]:* All HTTPS REST API interactions, WebSocket data streams, and client communications shall mandate TLS 1.3 transport layer security with cipher suites enforcing perfect forward secrecy (PFS).
2. *NFR-SEC-1.2 [MQTT X.509 Authentication]:* Hardware IoT sensors connecting to the MQTT broker gateway shall authenticate using unique device X.509 digital certificates over TLS Port 8883. Plaintext MQTT connections (Port 1883) shall be explicitly blocked at the firewall.

== Data Encryption at Rest & Password Hashing
1. *NFR-SEC-2.1 [Database Storage Encryption]:* All persistent databases (PostgreSQL/Firestore) and cloud object storage buckets (incident images) shall mandate AES-256 hardware encryption at rest.
2. *NFR-SEC-2.2 [Password Hashing Standard]:* User credentials shall be salted and hashed using Argon2id (64 MB memory) or bcrypt with at least 12 rounds. Plaintext password storage is strictly prohibited.

== Granular Role-Based Access Control (RBAC)
The system enforces strict permission boundaries across user roles:

#styled-table(
  columns: (1.2fr, 1fr, 1fr, 1fr, 1fr),
  headers: ("System Feature / API Resource", "Citizen User", "Driver Fleet", "Admin Ops", "System Engineer"),
  "Submit Dumping Incident & Photo", "CREATE", "READ", "READ / DELETE", "FULL ACCESS",
  "View Active Truck Route Navigation", "NO ACCESS", "READ / UPDATE", "READ / CREATE", "FULL ACCESS",
  "Modify Bin Threshold Configs", "NO ACCESS", "NO ACCESS", "UPDATE", "FULL ACCESS",
  "Access Raw Telemetry & DB Schemas", "NO ACCESS", "NO ACCESS", "READ ONLY", "FULL ACCESS",
  "Manage User Accounts & Roles", "NO ACCESS", "NO ACCESS", "NO ACCESS", "FULL ACCESS"
)

== API Rate Limiting & DoS Mitigation
1. *NFR-SEC-3.1 [Token Bucket Rate Limiting]:* Public API endpoints shall implement rate-limiting caps restricting incoming requests to a maximum of 100 requests per minute per authenticated JWT / client IP address.
2. *NFR-SEC-3.2 [DDoS Protection]:* The edge network layer (Cloudflare / AWS Shield) shall automatically mitigate layer 3/4/7 DDoS attacks, filtering malicious volumetric traffic prior to reaching backend application pods.

== Geolocation Anonymization & Privacy Compliance
1. *NFR-SEC-4.1 [EXIF Data Stripping]:* Citizen incident report image processing pipelines shall strip sensitive EXIF metadata (camera serial numbers, device model) while extracting only spatial coordinates.
2. *NFR-SEC-4.2 [Spatial Location Fuzzing]:* Publicly accessible maps displaying citizen-reported dumping locations shall apply a random spatial fuzzing offset (±50 meters) to protect citizen home privacy.

#pagebreak(weak: true)

= Safety, Hazard Mitigation & Regulatory Compliance

== Real-Time Hazard Alerting Latency
1. *NFR-SAF-1.1 [Fire & Gas Emergency Broadcast]:* If a smart bin sensor detects an internal temperature exceeding 60°C or hazardous methane concentration exceeding 500 PPM, the system shall broadcast high-priority visual and auditory alerts to the municipal command center in under 2.0 seconds.
2. *NFR-SAF-1.2 [Emergency Dispatch Automation]:* Fire hazard alerts shall automatically generate priority dispatch waypoints pushed directly to the nearest available collection unit and local fire department API.

== Driver Vehicle Motion Lockout Safety Feature
1. *NFR-SAF-2.1 [Driver Motion Lockout]:* To prevent distracted driving, the driver mobile application shall automatically disable interactive text inputs, manual form submissions, and non-essential UI buttons whenever vehicle velocity exceeds 10 km/h.
2. *NFR-SAF-2.2 [Voice & Large-Button UI]:* While in motion, the driver application shall display only high-contrast turn-by-turn map navigation and voice-guided audio prompts.

== Municipal Data Governance & Regulatory Compliance
1. *NFR-SAF-3.1 [GDPR & Municipal Data Compliance]:* The system shall fully comply with regional digital data protection regulations, providing citizens with right-to-be-forgotten user account deletion and data export features.
2. *NFR-SAF-3.2 [Audit Logging]:* All administrative configuration changes, threshold modifications, and vehicle dispatches shall be recorded in an append-only, immutable audit log retained for a minimum of 36 months.

#pagebreak(weak: true)

= Maintainability, Portability & Software Quality

== Cloud Auto-Scaling & Infrastructure
1. *NFR-MAINT-1.1 [Horizontal Container Scaling]:* Backend application services running on Kubernetes shall dynamically scale container pod instances based on CPU and memory utilization thresholds (exceeding 70% CPU utilization triggers scaling from 2 up to 20 pods).
2. *NFR-MAINT-1.2 [Infrastructure as Code (IaC)]:* All cloud infrastructure, security group rules, load balancers, and database clusters shall be defined and managed using Terraform configuration scripts to ensure reproducible deployments.

== Testability & Code Coverage
1. *NFR-MAINT-2.1 [Automated Code Coverage]:* The application codebase shall maintain a minimum automated unit and integration test code coverage of at least 85% across core business logic modules.
2. *NFR-MAINT-2.2 [CI/CD Automated Testing]:* Automated CI/CD deployment pipelines (GitHub Actions) shall execute linting, static security analysis (SonarQube), unit tests, and build checks prior to merging code into production branches.

== Usability & Accessibility Compliance
1. *NFR-MAINT-3.1 [WCAG 2.1 AA Compliance]:* Citizen and administrator web portals shall conform strictly to Web Content Accessibility Guidelines (WCAG 2.1 Level AA), ensuring screen reader compatibility, keyboard navigation, and APCA-compliant color contrast ratios (at least 4.5:1).
2. *NFR-MAINT-3.2 [Driver High-Contrast Dark Mode]:* Driver mobile displays shall feature an optimized dark mode theme with enlarged target buttons (at least 48 x 48 dp) designed for operation in low-light and bright sunlight cab environments.

#pagebreak(weak: true)

= Sustainability & Power Budgeting

== IoT Low-Power Telemetry & Battery Lifespan
1. *NFR-SUST-1.1 [Sensor Battery Lifespan]:* Smart bin IoT sensor nodes powered by internal LiSOCl2 batteries shall achieve an operational lifespan of at least 3 years under a standard telemetry transmission rate of 1 message per hour.
2. *NFR-SUST-1.2 [Adaptive Polling Frequency]:* To conserve battery power, sensor nodes shall dynamically adjust polling frequency based on bin fill states:
  - *Normal Fill (below 50%):* Telemetry published once every 2 hours.
  - *High Fill (50% to 84%):* Telemetry published once every 30 minutes.
  - *Critical Fill (85% and above):* Telemetry published once every 5 minutes.

== Carbon Footprint Tracking & Fleet Emissions Reduction
1. *NFR-SUST-2.1 [CO2 Reduction Calculation]:* The system analytics engine shall calculate cumulative CO2 emissions and fuel saved resulting from dynamic route optimization compared to traditional static scheduled routes (using a standard factor of 2.68 kg CO2 per liter of diesel).
2. *NFR-SUST-2.2 [Target Fleet Fuel Savings]:* Dynamic route optimization shall target a minimum overall reduction of 18% in total vehicle kilometers traveled across the municipal collection fleet.

#pagebreak(weak: true)

= NFR Verification & Traceability Matrix

This matrix maps each Non-Functional Requirement to its quantitative target, verification methodology, and operational priority:

#styled-table(
  columns: (1.2fr, 1.2fr, 2.2fr, 1fr, 0.8fr),
  headers: ("Requirement ID", "Category", "Quantitative Target / Metric", "Verification Method", "Priority"),
  "NFR-PERF-1.1", "Performance", "MQTT ingestion P95 < 50ms at 10k msg/min", "Load Testing (JMeter)", "P1",
  "NFR-PERF-2.1", "Performance", "PostGIS spatial bin search < 25ms", "Database Profiling", "P2",
  "NFR-REL-1.1", "Reliability", "99.95% system uptime SLA", "Monitoring (Prometheus)", "P1",
  "NFR-REL-2.1", "Reliability", "Offline driver SQLite logging & 10s sync", "Field Test Simulation", "P2",
  "NFR-SEC-1.1", "Security", "TLS 1.3 mandatory encryption for HTTPS", "Penetration Audit", "P1",
  "NFR-SEC-1.2", "Security", "MQTT TLS 8883 with X.509 device certs", "Security Inspection", "P1",
  "NFR-SEC-2.2", "Security", "Argon2id / bcrypt 12 rounds password hash", "Code Audit", "P1",
  "NFR-SAF-1.1", "Safety", "Fire/Gas alert broadcast latency < 2.0s", "Automated Integration Test", "P1",
  "NFR-SAF-2.1", "Safety", "Driver app input lockout when speed > 10km/h", "GPS Speed Simulation", "P1",
  "NFR-MAINT-1.1", "Scalability", "Kubernetes pod auto-scaling at >70% CPU", "Stress Testing", "P2",
  "NFR-MAINT-2.1", "Maintainability", ">= 85% automated unit test coverage", "CI/CD Test Runner", "P3",
  "NFR-SUST-1.1", "Sustainability", ">= 3-year sensor battery lifespan", "Power Profile Analysis", "P2",
  "NFR-SUST-2.1", "Sustainability", ">= 18% reduction in fleet fuel consumption", "Fleet Telemetry Audit", "P2"
)
