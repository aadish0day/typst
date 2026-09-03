// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set document(
  title: "Smart Waste Management System - Final Software Requirements Specification",
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
    #text(size: 12pt, style: "italic")[Submission: Final Software Requirements Specification (IEEE Std 830-1998 Master Baseline)]
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
  "1.0.0", "2026-08-27", "Initial IEEE Std 830-1998 compliant SRS draft specification.", "Aadish Das (24BIT010)",
  "1.1.0", "2026-08-27", "Integrated functional requirements across IoT, dynamic routing, and AI sorting.", "Aadish Das (24BIT010)",
  "2.0.0", "2026-08-27", "Final Master SRS baseline unifying Functional, Non-Functional, System Diagrams, and Verification Traceability.", "Aadish Das (24BIT010)",
)

#v(1em)

= Introduction

== Purpose
This document represents the *Final Software Requirements Specification (SRS)* for the *Smart Waste Management System (SWMS)*. It provides the definitive, comprehensive engineering specification covering all functional capabilities, non-functional quality attributes, external interfaces, database schemas, and architectural boundaries. 

This document serves as the binding reference baseline for software development, system integration, municipal deployment, and quality assurance verification, strictly adhering to the *IEEE Std 830-1998* specification standard.

== Document Conventions
- *Requirement Tags:* Functional requirements are tagged as `FR-[Module].[ID]` and Non-Functional requirements as `NFR-[Domain].[ID]`.
- *Prioritization:* Rated as High (*H* / P1), Medium (*M* / P2), and Low (*L* / P3).
- *Clear Descriptions:* Requirements, thresholds, and operational rules are expressed in clear, simple language without unnecessary mathematical formulas.

== Intended Audience and Reading Suggestions
- *Municipal Leadership & Project Sponsors:* Read Sections 1–2 for vision, high-level scope, and system boundaries.
- *System Architects & Backend Engineers:* Consult Sections 3, 4, 5, and 6 for technical interfaces, API specifications, and database models.
- *IoT Hardware Engineers:* Review Section 3.2 and Section 4.1 for MQTT telemetry and sensor threshold parameters.
- *QA Test Engineers:* Utilize Appendix C (Requirements Verification & Traceability Matrix) for test plan creation.

== Product Scope
The *Smart Waste Management System (SWMS)* is an IoT-driven municipal platform designed to modernize urban waste management:
1. *Smart Container Telemetry:* Ultrasonic fill monitoring, internal temperature detection, tilt alerts, and battery tracking.
2. *Dynamic Route Optimization:* Automated truck route generation minimizing fuel consumption and travel time.
3. *Citizen Reporting:* Geotagged photo submissions for illegal dumping and overflowing containers.
4. *AI Waste Classification:* Machine learning image recognition for automated material sorting.
5. *Municipal Operations Center:* Interactive GIS dashboard displaying live heatmaps, vehicle tracking, and sustainability metrics.

== References
1. IEEE Computer Society, *IEEE Std 830-1998: IEEE Recommended Practice for Software Requirements Specifications*, IEEE, 1998.
2. ISO/IEC/IEEE 29148:2018, *Software and systems engineering — Lifecycle processes — Requirements engineering*, 2018.
3. Open Geospatial Consortium (OGC), *GeoJSON Format Specification*, RFC 7946, 2016.
4. OASIS Open, *MQTT Version 5.0 Specification*, OASIS Standard, 2019.

#pagebreak(weak: true)

= Overall Description

== Product Perspective
The Smart Waste Management System is a distributed, multi-tiered urban management platform integrating IoT hardware nodes, cloud gateway services, analytical microservices, and multi-platform client applications.

#responsive-image("attachments/dfd_level_0.svg", width: 100%)

== Product Functions
- *Container Telemetry Processing:* Real-time IoT sensor data decoding, threshold validation, and alert triggering.
- *Dynamic Logistics Routing:* Heuristic route optimization for municipal vehicle fleets.
- *Citizen Incident Workflow:* Mobile submission, crowd verification, and resolution status notification.
- *AI Image Categorization:* Visual waste type classification (Dry, Wet, Recyclable, Hazardous, E-waste).
- *Driver Navigation & Field Logging:* Turn-by-turn routing, collection logging, and obstacle flagging.
- *Municipal Analytics:* GIS heatmap visualizations, carbon reduction tracking, and executive report generation.

== User Classes and Characteristics
#styled-table(
  columns: (1.2fr, 1fr, 2.5fr),
  headers: ("User Class", "Access Level", "Key Characteristics & Technical Expertise"),
  "Citizen Public User", "Public Client", "Low technical expertise. Interacts via mobile/web portal to report incidents, locate recycling bins, and earn green points.",
  "Collection Driver", "Mobile Operational", "Medium technical expertise. Uses mobile tablet apps for route navigation, pickup verification, and collection logging.",
  "Municipal Admin", "Operations Command", "High technical expertise. Oversees city-wide waste operations, manages fleet schedules, and monitors analytics.",
  "System Administrator", "Full Root Access", "Expert level. Manages server infrastructure, database security, user roles, and system configurations."
)

== Operating Environment
- *Client Portals:* Web browsers (Chrome 115+, Firefox 115+, Safari 16+, Edge); Mobile (Android 10.0+ / iOS 15.0+).
- *Backend Runtime:* Node.js 20 LTS, Docker containers, Kubernetes orchestration.
- *Database Tier:* PostgreSQL 15 with PostGIS spatial extension / Cloud Firestore.
- *IoT Messaging Gateway:* MQTT Broker over TLS (Port 8883) with X.509 device certificates.

== Design and Implementation Constraints
1. *Edge Telemetry Buffering:* Local data buffering on edge gateways during cellular network outages.
2. *Real-Time Hazard Alerting:* High-priority alert broadcast within 2.0 seconds of fire or methane gas detection.
3. *Mobile Data Compression:* Image uploads compressed on the device to under 300 KB before upload.
4. *Data Privacy:* Full compliance with municipal privacy regulations and GDPR standards.

== User Documentation
- *Citizen User Guide & App Onboarding Flow* (Interactive mobile tutorial).
- *Collection Driver Field Manual* (PDF & interactive tablet manual).
- *Municipal Administrator Command Center Guide* (Comprehensive 50-page documentation).
- *OpenAPI 3.0 REST & Webhook Specification* (Swagger documentation).

== Assumptions and Dependencies
- *GPS Accuracy:* Mobile devices and vehicle GPS hardware provide accuracy within 5 meters.
- *Cellular Infrastructure:* Continuous 4G LTE or NB-IoT coverage across municipal sectors.
- *Mapping APIs:* Reliance on Google Maps / OpenStreetMap APIs for spatial routing and map tile rendering.

#pagebreak(weak: true)

= External Interface Requirements

== User Interfaces
- *Citizen Portal:* Responsive web and mobile layout supporting camera photo capture, automatic location detection, and incident tracking.
- *Driver Navigation View:* High-contrast dark mode display with large touch buttons (at least 48 x 48 dp) designed for in-cab use.
- *Municipal Command Center:* Multi-pane dashboard featuring interactive GIS heatmaps, live vehicle telemetry markers, and analytical charts.

== Hardware Interfaces
- *IoT Smart Bin Sensors:* Ultrasonic distance sensor (range 2 cm to 400 cm), 3-axis tilt sensor, temperature sensor, and cellular modem.
- *Driver Mobile Hardware:* Integration with device GPS receiver, camera, and Bluetooth OBD-II vehicle diagnostic adapters.

== Software Interfaces
#styled-table(
  columns: (1.5fr, 1.2fr, 2.5fr),
  headers: ("Interface Name", "Provider / Standard", "Purpose & Interaction Protocol"),
  "GIS Map Engine", "Google Maps / Mapbox", "Map tile rendering, spatial geocoding, and polyline route display via HTTPS REST SDK.",
  "AI Vision Engine", "TensorFlow Lite", "On-device and cloud image classification for waste sorting verification.",
  "Auth Provider", "Firebase Auth / OAuth 2.0", "Multi-factor authentication and JSON Web Token (JWT) identity management.",
  "Push Notification", "FCM (Firebase Cloud)", "Real-time alerts to drivers (new route) and citizens (report resolved)."
)

== Communications Interfaces
- *MQTT over TLS (Port 8883):* Secure publish-subscribe transport for IoT sensor telemetry.
- *HTTPS / REST (Port 443):* Secure JSON API protocol for client application interactions.
- *WebSockets (WSS):* Bi-directional socket streams for live vehicle GIS tracking on municipal maps.

#pagebreak(weak: true)

= System Features (Functional Requirements)

== Feature 1: IoT Smart Bin Telemetry & Threshold Processing

=== Description and Priority
Ingests and processes telemetry data streamed from city-wide IoT waste container sensors.
*Priority:* High (*H* / P1).

=== Detailed Functional Requirements
- *FR-1.1 [Telemetry Ingestion]:* The system shall ingest MQTT telemetry payloads at up to 10,000 messages per minute with a response time under 100 ms.
- *FR-1.2 [Fill Level Calculation]:* The system shall compute the container fill percentage from ultrasonic distance measurements relative to total container height.
- *FR-1.3 [Critical Overflow Alert]:* The system shall flag bin status as `CRITICAL_OVERFLOW` when fill level reaches 85% or higher for two consecutive readings.
- *FR-1.4 [Hazard Detection]:* The system shall broadcast a `FIRE_HAZARD` alert within 2 seconds if internal temperature exceeds 60°C or tilt angle exceeds 45°.
- *FR-1.5 [Battery Monitoring]:* The system shall auto-generate a maintenance ticket when sensor battery drops below 15%.

== Feature 2: Dynamic Collection Route Optimization

=== Description and Priority
Calculates fuel-optimized collection truck routes based on real-time bin priority and traffic data.
*Priority:* High (*H* / P1).

=== Detailed Functional Requirements
- *FR-2.1 [Priority Bin Selection]:* The system shall identify and prioritize all bins that are overflowing or nearly full (70% capacity or higher).
- *FR-2.2 [Route Optimization]:* The system shall calculate the shortest, most efficient collection route to visit all prioritized bins without exceeding truck capacity.
- *FR-2.3 [Real-Time Dynamic Rerouting]:* The system shall dynamically reroute active trucks if traffic delays increase by more than 25%.
- *FR-2.4 [Manual Pickup Insertion]:* Municipal admins shall have permission to manually insert emergency waypoints into active truck manifests.
- *FR-2.5 [Export Manifest]:* The system shall export routes in standard GeoJSON and GPX formats.

== Feature 3: Citizen Incident & Illegal Dumping Reporting

=== Description and Priority
Enables citizens to submit geotagged incident reports regarding overflowing bins or illegal dumping.
*Priority:* Medium (*M* / P2).

=== Detailed Functional Requirements
- *FR-3.1 [Geotagged Photo Capture]:* The system shall capture photo imagery with GPS coordinates (within ±5 meters accuracy) and timestamp.
- *FR-3.2 [Client Image Compression]:* Client apps shall compress uploaded photos to a maximum resolution of 1920 x 1080 pixels (under 300 KB).
- *FR-3.3 [Duplicate Incident Filtering]:* The system shall filter duplicate incidents reported within a 25-meter radius and 4-hour window.
- *FR-3.4 [Incident Lifecycle Workflow]:* The system shall transition incident tickets: `SUBMITTED` -> `VERIFIED` -> `DISPATCHED` -> `RESOLVED`.
- *FR-3.5 [Citizen Reward Points]:* The system shall credit green community reward points upon verified ticket resolution.

== Feature 4: Waste Categorization & AI Image Recognition

=== Description and Priority
Classifies uploaded incident imagery using machine learning models to determine waste categories and volume.
*Priority:* Medium (*M* / P2).

=== Detailed Functional Requirements
- *FR-4.1 [Multi-Class Classification]:* The vision service shall classify images into 5 categories (`DRY`, `WET`, `RECYCLABLE`, `HAZARDOUS`, `E-WASTE`) with at least 88% target accuracy.
- *FR-4.2 [Confidence Auditing]:* Classification confidence below 0.70 (70%) shall tag the report as `REQUIRES_MANUAL_AUDIT`.
- *FR-4.3 [Hazard Auto-Escalation]:* Images classified as `HAZARDOUS` or `BIO_MEDICAL` shall trigger immediate priority alerts.
- *FR-4.4 [Volume Estimation]:* The system shall estimate waste pile volume (in cubic meters) using bounding-box spatial geometry.

== Feature 5: Fleet Driver Navigation & Mobile Logging

=== Description and Priority
Provides driver tablet applications with route guidance, pickup logging, and vehicle status reporting.
*Priority:* High (*H* / P1).

=== Detailed Functional Requirements
- *FR-5.1 [Automated Waypoint Check-In]:* The system shall auto-log pickup completion when vehicle remains within 15 meters of target bin for at least 45 seconds.
- *FR-5.2 [Manual Collection Logging]:* Drivers shall have permission to manually log pickup completion with optional photo proof.
- *FR-5.3 [Obstacle & Issue Reporting]:* Drivers shall report road blockages or damaged bins directly from navigation screen.
- *FR-5.4 [Offline SQLite Sync]:* Mobile driver apps shall store collection logs locally during offline cellular dead-zones and sync upon reconnecting.

== Feature 6: Municipal Analytics & Sustainability Dashboard

=== Description and Priority
Executive analytics dashboard displaying operational efficiency, GIS heatmaps, and environmental impact metrics.
*Priority:* High (*H* / P1).

=== Detailed Functional Requirements
- *FR-6.1 [Real-Time GIS Heatmap]:* The system shall render interactive maps displaying color-coded bin fill states (Green: below 50%, Yellow: 50% to 84%, Red: 85% or above).
- *FR-6.2 [Fleet Efficiency Analytics]:* The system shall track fuel consumption, kilometers per ton collected, and driver idle time.
- *FR-6.3 [CO2 Reduction Calculation]:* The system shall compute estimated CO2 emissions and fuel saved from route optimization (based on 2.68 kg CO2 saved per liter of diesel).
- *FR-6.4 [Automated Executive PDF Reports]:* The system shall generate scheduled weekly executive PDF summary reports sent via email.
- *FR-6.5 [Data Exporting]:* The system shall export historical data logs in CSV, JSON, and Excel formats.

== Feature 7: User Authentication & Role-Based Access Control

=== Description and Priority
Ensures secure multi-tenant identity verification and granular permission enforcement.
*Priority:* High (*H* / P1).

=== Detailed Functional Requirements
- *FR-7.1 [Multi-Factor Authentication]:* The system shall support SMS/Email OTP two-factor authentication for administrative accounts.
- *FR-7.2 [Role-Based Access Control (RBAC)]:* The system shall strictly enforce permission matrices across `CITIZEN`, `DRIVER`, `ADMIN`, and `ENGINEER` roles.
- *FR-7.3 [Session Token Expiration]:* JWT access tokens shall expire after 60 minutes of inactivity, requiring refresh token exchange.
- *FR-7.4 [Immutable Audit Logging]:* All administrative actions and threshold overrides shall be logged in an append-only audit log.

#pagebreak(weak: true)

= Non-Functional Requirements Specification

== Performance & Throughput Requirements
- *NFR-PERF-1:* Web dashboard pages shall achieve First Contentful Paint (FCP) under 1.0 second and Time to Interactive (TTI) under 2.0 seconds.
- *NFR-PERF-2:* REST API endpoints shall maintain P95 response latency under 120 ms under baseline load.
- *NFR-PERF-3:* Spatial bin proximity searches shall execute in under 25 ms.

== Reliability & Availability SLA
- *NFR-REL-1:* The core cloud application shall maintain a 99.95% service availability SLA (less than 4.38 hours unplanned downtime per year).
- *NFR-REL-2:* System Mean Time Between Failures (MTBF) shall exceed 720 hours, and Mean Time To Recovery (MTTR) shall be under 15 minutes.
- *NFR-REL-3:* Mobile apps shall support offline SQLite logging with automated synchronization when network reconnects.

== Security, Data Protection & Privacy
- *NFR-SEC-1:* All HTTPS REST and WebSocket interactions shall mandate TLS 1.3 encryption.
- *NFR-SEC-2:* MQTT IoT connections shall authenticate using X.509 device certificates over TLS Port 8883.
- *NFR-SEC-3:* Persistent databases and cloud file buckets shall enforce AES-256 storage encryption at rest.
- *NFR-SEC-4:* User passwords shall be salted and hashed using Argon2id (64 MB memory) or bcrypt (12 rounds).
- *NFR-SEC-5:* Public API endpoints shall enforce rate-limiting caps (100 requests per minute).

== Safety & Hazard Mitigation
- *NFR-SAF-1:* Fire or methane gas alerts shall broadcast visual and auditory alerts to dispatchers within 2 seconds.
- *NFR-SAF-2:* Driver mobile apps shall lock out text input when vehicle speed exceeds 10 km/h.

== Maintainability & Software Quality
- *NFR-MAINT-1:* Backend Kubernetes services shall auto-scale container pods when CPU utilization exceeds 70%.
- *NFR-MAINT-2:* Application codebase shall maintain at least 85% automated unit and integration test coverage.
- *NFR-MAINT-3:* User interfaces shall comply with WCAG 2.1 Level AA accessibility standards.

== Sustainability & Power Budgeting
- *NFR-SUST-1:* IoT bin sensor nodes shall achieve an operational battery life of at least 3 years using adaptive reporting.
- *NFR-SUST-2:* Route optimization shall target a minimum overall reduction of 18% in total fleet vehicle kilometers.

#pagebreak(weak: true)

= Database & System Design Models

== Entity Relationship Architecture
The data model supports real-time telemetry logging, dynamic route assignments, spatial geocoding, and citizen incident management.

#responsive-image("attachments/er_diagram.svg", width: 100%)

== Schema Integrity & Spatial Constraints
1. *SmartBin Collection:* `bin_id` (UUID PK), `location` (Point Geometry), `fill_level_pct` (constrained between 0.0% and 100.0%).
2. *TelemetryLog Collection:* `log_id` (UUID PK), `bin_id` (FK), `recorded_at` (Timestamp Index Descending).
3. *IncidentReport Collection:* Geocoded location constrained within municipal boundaries (18.90° to 19.30° N, 72.75° to 73.00° E).

#pagebreak(weak: true)

= Appendix A: Glossary & Terminology

#styled-table(
  columns: (1.2fr, 2.8fr),
  headers: ("Term / Acronym", "Formal Definition & Context"),
  "SWMS", "Smart Waste Management System — The comprehensive urban platform specified herein.",
  "IoT", "Internet of Things — Network of physical objects embedded with sensors and connectivity.",
  "MQTT", "Message Queuing Telemetry Transport — Lightweight publish-subscribe protocol for IoT sensors.",
  "GPS", "Global Positioning System — Satellite navigation system providing geographic location coordinates.",
  "GeoJSON", "An open standard format for representing geographic feature geometry and spatial attributes.",
  "RBAC", "Role-Based Access Control — Security mechanism restricting access according to authorized user roles.",
  "SLA", "Service Level Agreement — Formally committed minimum availability uptime percentage target."
)

= Appendix B: Complete System Use Case Diagram

#responsive-image("attachments/use_case_diagram.svg", width: 100%)

= Appendix C: System Requirements Verification Matrix

#styled-table(
  columns: (1.2fr, 1.2fr, 2.2fr, 1fr, 0.8fr),
  headers: ("Requirement ID", "Type", "Quantitative Target Metric", "Verification Method", "Priority"),
  "FR-1.1", "Functional", "Ingest 10,000 MQTT msg/min with response < 100ms", "Load Testing", "P1",
  "FR-1.4", "Functional", "Fire/Gas alert broadcast latency < 2.0s", "Integration Test", "P1",
  "FR-2.2", "Functional", "Route optimization distance minimization", "Algorithm Verification", "P1",
  "FR-4.1", "Functional", "AI waste classification accuracy >= 88%", "Model Validation", "P2",
  "NFR-PERF-1", "Performance", "Web FCP < 1.0s, TTI < 2.0s", "Core Web Vitals Audit", "P2",
  "NFR-REL-1", "Reliability", "99.95% cloud service availability SLA", "Monitoring Audit", "P1",
  "NFR-SEC-1", "Security", "TLS 1.3 encryption & X.509 MQTT certs", "Penetration Audit", "P1",
  "NFR-SEC-3", "Security", "AES-256 storage encryption at rest", "Security Code Audit", "P1",
  "NFR-SAF-2", "Safety", "Driver app input lockout when speed > 10km/h", "GPS Speed Simulation", "P1",
  "NFR-SUST-1", "Sustainability", ">= 3-year sensor battery lifespan", "Power Profile Analysis", "P2"
)
