// === Master Setup Block ===
#let is-assembly = sys.inputs.at("mode", default: "standalone") == "blackbook"

#set document(
  title: "Smart Waste Management System - Functional Requirements SRS",
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
    #text(size: 12pt, style: "italic")[Submission: Functional Requirements — Software Requirements Specification (IEEE Std 830-1998)]
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
  "1.0.0", "2026-08-27", "Initial IEEE Std 830-1998 compliant SRS baseline specification for Smart Waste Management System.", "Aadish Das (24BIT010)",
  "1.1.0", "2026-08-27", "Refined functional requirements across IoT telemetry, route optimization, AI sorting, and citizen reporting.", "Aadish Das (24BIT010)",
)

#v(1em)

= Introduction

== Purpose
This Software Requirements Specification (SRS) document details the complete functional, non-functional, interface, and behavioral requirements for the *Smart Waste Management System (SWMS)*. It establishes a formal contract between municipal waste management stakeholders, system architects, software developers, and quality assurance engineers. This specification aligns strictly with *IEEE Std 830-1998* recommendations for software requirements documentation.

== Document Conventions
The following typographic and organizational conventions are followed throughout this specification:
- *Heading Numbering:* Standard decimal numbering hierarchy (e.g., Section 1, 1.1, 1.1.1).
- *Functional Requirement Tags:* Unique identifier tags formatted as `FR-[FeatureGroup].[ItemNumber]` (e.g., `FR-1.1`, `FR-2.3`).
- *Requirement Priority:* Categorized into High (*H*), Medium (*M*), and Low (*L*).
- *Clear Specifications:* Requirements, thresholds, and operational limits are stated in clear, simple language without unnecessary mathematical formulas.

== Intended Audience and Reading Suggestions
This document is intended for:
- *Municipal Decision Makers & Urban Planners:* To review system capabilities, compliance, and sustainability impact metrics (Sections 1–2).
- *Software Architects & Engineering Teams:* To design backend microservices, data schemas, API gateways, and mobile/web interfaces (Sections 3–6).
- *IoT Hardware Engineers:* To implement MQTT telemetry protocols, sensor calibration algorithms, and power-budget constraints (Section 3.2, 4.1).
- *Quality Assurance & Test Teams:* To create unit, integration, and user acceptance test suites based on verifiable requirement statements (Section 4–5).

== Product Scope
The *Smart Waste Management System (SWMS)* is an end-to-end urban technology platform designed to transform traditional scheduled waste collection into a real-time, data-driven, dynamic collection operation. 

*Key Capabilities & System Goals:*
1. *Real-Time Telemetry:* Monitoring fill levels, tilt, gas emissions, and internal temperature across city-wide waste containers via low-power IoT ultrasonic sensors.
2. *Dynamic Route Optimization:* Automated calculation of optimal collection truck dispatch routes based on fill-level thresholds, traffic patterns, and vehicle capacities.
3. *Citizen Engagement:* Mobile/Web reporting portal allowing citizens to upload photos of overflowing bins or illegal dumping, geotagged with high-precision GPS coordinates.
4. *AI-Powered Waste Classification:* Automated visual classification of waste types (Dry, Wet, Recyclable, Hazardous, E-waste) using computer vision models.
5. *Municipal Operations Command Center:* Centralized dashboard displaying live GIS maps, driver status, fleet efficiency, and carbon emissions reduction tracking.

== References
1. IEEE Computer Society, *IEEE Std 830-1998: IEEE Recommended Practice for Software Requirements Specifications*, IEEE, 1998.
2. ISO/IEC/IEEE 29148:2018, *Systems and software engineering — Life cycle processes — Requirements engineering*, 2018.
3. Open Geospatial Consortium (OGC), *GeoJSON Format Specification*, RFC 7946, 2016.
4. OASIS Open, *MQTT Version 5.0 Specification*, OASIS Standard, 2019.

#pagebreak(weak: true)

= Overall Description

== Product Perspective
The Smart Waste Management System operates as a distributed multi-tier urban platform, bridging hardware sensors, edge cloud gateways, analytical backend services, and multi-role user clients. 

#responsive-image("attachments/dfd_level_0.svg", width: 100%)

== Product Functions
The high-level capabilities provided by the system include:
- *IoT Container Monitoring:* Continuous telemetry ingestion, anomaly detection (fire/tilt), and battery level monitoring.
- *Dynamic Logistics Dispatch:* Heuristic route optimization minimizing fuel consumption and vehicle wear.
- *Citizen Incident Reporting:* Geo-tagged photo submission, crowd-sourced verification, and resolution status notification.
- *AI Waste Categorization:* Image-based waste classification assisting material recovery facilities.
- *Fleet Management & Driver Assistance:* Turn-by-turn navigation, collection logging, and bin maintenance flagging.
- *Executive Municipal Analytics:* Live operational heatmaps, trend forecasting, and worker efficiency indices.

== User Classes and Characteristics
#styled-table(
  columns: (1.2fr, 1fr, 2.5fr),
  headers: ("User Class", "Access Level", "Key Characteristics & Technical Expertise"),
  "Citizen Public User", "Public Client", "Low technical expertise. Interacts via iOS/Android/Web app to report dumping, view public bin locations, and earn green reward points.",
  "Collection Driver", "Mobile Operational", "Medium technical expertise. Uses ruggedized mobile tablets/phones for turn-by-turn route navigation, bin emptying confirmations, and obstacle logs.",
  "Municipal Admin", "Operations Command", "High technical expertise. Oversees city-wide waste operations, manages fleet schedules, configures sensor thresholds, and generates compliance reports.",
  "System Administrator", "Full Root Access", "Expert level. Manages server infrastructure, database backups, API keys, role permissions, and system security policies."
)

== Operating Environment
- *Client Web Applications:* Modern web browsers (Google Chrome 115+, Mozilla Firefox 115+, Safari 16+, Edge).
- *Client Mobile Applications:* Android 10.0 (API Level 29) or higher; iOS 15.0 or higher.
- *Backend Server Platform:* Node.js 20 LTS runtime, Docker containers, Kubernetes orchestration.
- *Database Management System:* Cloud Firestore / PostgreSQL 15 with PostGIS spatial extension.
- *IoT Gateway Environment:* MQTT Broker (Eclipse Mosquitto / AWS IoT Core) supporting TLS 1.3 encryption.

== Design and Implementation Constraints
1. *Network Resilience:* Telemetry payloads must be buffered locally at edge gateways during cellular connectivity outages.
2. *Real-Time Latency:* Sensor alert processing (fire or tilt detection) must execute within 2.0 seconds of payload arrival.
3. *Mobile Data Optimization:* Citizen photo uploads must be compressed on the device to under 300 KB before transmission over cellular data networks.
4. *Regulatory Compliance:* Data privacy and user location logging must strictly conform to municipal digital privacy regulations and GDPR guidelines.

== User Documentation
Delivered documentation components include:
- *Citizen User Guide & Mobile Onboarding Tutorial* (Embedded mobile App flow).
- *Collector & Driver Operational Field Manual* (PDF & interactive mobile guide).
- *Municipal Administrator Command Center User Manual* (Comprehensive 50-page document).
- *REST API & Webhook Technical Reference Specification* (Swagger / OpenAPI 3.0).

== Assumptions and Dependencies
- *GPS Accuracy:* Assumes client mobile devices and vehicle telematics hardware provide GPS accuracy within 5 meters.
- *Cellular Coverage:* Assumes 4G LTE or NB-IoT network coverage across urban collection sectors.
- *Third-Party Services:* Relies on Google Maps / OpenStreetMap APIs for spatial routing and map tile rendering.

#pagebreak(weak: true)

= External Interface Requirements

== User Interfaces
The system provides tailored, role-specific visual interfaces:
- *Citizen Portal:* Clean, modern interface supporting camera integration, automatic location detection, map view of nearby recycled bins, and submission tracking.
- *Driver Navigation View:* High-contrast dark mode display with large touch targets designed for vehicular cab use, providing sequential waypoint navigation.
- *Municipal Control Center:* High-density multi-pane dashboard with interactive GIS heatmaps, live vehicle telemetry markers, interactive charts, and emergency alert banners.

== Hardware Interfaces
- *IoT Smart Bin Sensors:* Ultrasonic distance sensor (range 2 cm to 400 cm), 3-axis tilt sensor, temperature sensor, and cellular modem.
- *Driver Mobile Hardware:* Integration with device GPS receiver, camera unit, and Bluetooth OBD-II vehicle diagnostic adapters.

== Software Interfaces
#styled-table(
  columns: (1.5fr, 1.2fr, 2.5fr),
  headers: ("Interface Name", "Provider / Standard", "Purpose & Interaction Protocol"),
  "GIS Map Engine", "Google Maps / Mapbox", "Vector map tile rendering, spatial geocoding, and route polyline display via HTTPS REST SDK.",
  "AI Vision Engine", "TensorFlow Lite", "On-device or edge-cloud image classification for waste sorting verification.",
  "Authentication Provider", "Firebase Auth / OAuth 2.0", "Secure multi-factor authentication and JSON Web Token (JWT) issuing.",
  "Push Notification", "FCM (Firebase Cloud)", "Real-time push alerts to drivers (new route assigned) and citizens (report resolved)."
)

== Communications Interfaces
- *MQTT over TLS (Port 8883):* Lightweight publish/subscribe protocol for IoT smart bin sensor telemetry payload transmission.
- *HTTPS / REST (Port 443):* Secure JSON API transport for web/mobile client interaction with backend cloud services.
- *WebSockets (WSS):* Bi-directional real-time socket connections for updating municipal dashboard GIS maps with live truck coordinates.

#pagebreak(weak: true)

= System Features (Functional Requirements)

== System Feature 1: IoT Smart Bin Telemetry & Threshold Processing

=== Description and Priority
The system continuously ingests, validates, and processes telemetry data streamed from IoT sensors attached to municipal waste containers across the city.
*Priority:* High (*H*).

=== Stimulus/Response Sequences
- *Stimulus:* Smart bin sensor publishes MQTT payload containing fill distance, temperature, tilt angle, and battery percentage.
- *Response:* Server decodes payload, calculates fill level percentage, logs telemetry record, and triggers an alert if fill level reaches 85% or higher, or if temperature exceeds 60°C.

=== Detailed Functional Requirements
- *FR-1.1 [Telemetry Ingestion]:* The system shall ingest MQTT telemetry payloads at a rate of up to 10,000 messages per minute with an acknowledgment response time under 100 ms.
- *FR-1.2 [Fill Level Calculation]:* The system shall compute the current bin fill level percentage based on ultrasonic distance measurement relative to total container height.
- *FR-1.3 [Threshold Alert Generation]:* The system shall automatically mark a bin status as `CRITICAL_OVERFLOW` when fill level reaches 85% or higher for two consecutive polling intervals.
- *FR-1.4 [Hazard Detection]:* The system shall trigger an immediate `FIRE_HAZARD` alarm to the municipal dashboard if internal bin temperature exceeds 60°C or tilt angle exceeds 45°.
- *FR-1.5 [Battery Health Monitoring]:* The system shall generate a maintenance ticket when sensor battery voltage drops below 15%.

== System Feature 2: Dynamic Collection Route Optimization

=== Description and Priority
Calculates fuel-efficient, time-optimized collection routes for municipal waste trucks based on real-time bin priority and traffic data.
*Priority:* High (*H*).

=== Stimulus/Response Sequences
- *Stimulus:* Municipal administrator initiates automated dispatch or scheduled system cron triggers route generation.
- *Response:* Route optimization engine queries critical bins, executes vehicle routing algorithms, generates sequential waypoint polylines, and assigns routes to active drivers.

=== Detailed Functional Requirements
- *FR-2.1 [Priority Waypoint Clustering]:* The system shall select all bins with status `CRITICAL_OVERFLOW` or `HIGH_PRIORITY` (70% capacity or higher) within a designated collection sector.
- *FR-2.2 [Route Optimization Objective]:* The system shall calculate the shortest, most efficient collection truck route to visit prioritized bins while ensuring total collected waste remains within truck capacity limits.
- *FR-2.3 [Real-Time Traffic Integration]:* The system shall re-route active collection vehicles dynamically if live traffic delays on the assigned route increase by more than 25%.
- *FR-2.4 [Manual Route Modification]:* The municipal admin shall have the capability to manually insert emergency pick-up waypoints into an active driver's route.
- *FR-2.5 [Export Route Manifest]:* The system shall export generated routes in standard GeoJSON and GPX formats for navigation hardware compatibility.

#pagebreak(weak: true)

== System Feature 3: Citizen Incident & Illegal Dumping Reporting

=== Description and Priority
Provides citizens with a mobile and web interface to submit geotagged incident reports regarding overflowing bins, damaged containers, or illegal dumping sites.
*Priority:* Medium (*M*).

=== Stimulus/Response Sequences
- *Stimulus:* Citizen opens mobile app, captures a photo of illegal dumping, and clicks "Submit Report".
- *Response:* App captures high-precision GPS coordinates, compresses image, uploads payload to cloud storage, creates an incident ticket, and provides a tracking ID to the citizen.

=== Detailed Functional Requirements
- *FR-3.1 [Geo-Tagged Photo Capture]:* The system shall capture camera imagery accompanied by GPS coordinates (within ±5 meters accuracy) and timestamp.
- *FR-3.2 [Client Image Compression]:* The mobile client shall downscale uploaded images to a maximum resolution of 1920 x 1080 pixels and apply JPEG compression (under 300 KB).
- *FR-3.3 [Duplicate Incident Filtering]:* The system shall perform spatial proximity matching (within 25 meters) on newly reported incidents to prevent duplicate tickets for the same location within a 4-hour window.
- *FR-3.4 [Incident Lifecycle Management]:* The system shall transition incident status through defined states: `SUBMITTED` -> `VERIFIED` -> `DISPATCHED` -> `RESOLVED`.
- *FR-3.5 [Citizen Reward Points]:* The system shall credit green community reward points to verified citizen accounts upon ticket resolution.

== System Feature 4: Waste Categorization & AI Image Recognition

=== Description and Priority
Analyzes uploaded imagery using machine learning classification models to determine waste categories and estimate volume.
*Priority:* Medium (*M*).

=== Stimulus/Response Sequences
- *Stimulus:* Incident photo uploaded to storage bucket.
- *Response:* Automated vision service executes classification model, tags primary waste category (`DRY`, `WET`, `RECYCLABLE`, `HAZARDOUS`, `E-WASTE`), and assigns confidence score.

=== Detailed Functional Requirements
- *FR-4.1 [Multi-Class Waste Identification]:* The system shall classify waste images into five distinct categories with a minimum target accuracy of 88%.
- *FR-4.2 [Confidence Thresholding]:* If classification confidence score is below 0.70 (70%), the system shall mark category as `REQUIRES_MANUAL_AUDIT` for municipal operator review.
- *FR-4.3 [Hazard Auto-Escalation]:* Image classification resulting in `HAZARDOUS` or `BIO_MEDICAL` tags shall automatically alert specialized handling units.
- *FR-4.4 [Volume Estimation]:* The system shall estimate waste heap volume (in cubic meters) using bounding-box spatial geometry.

== System Feature 5: Fleet Driver Navigation & Mobile Logging

=== Description and Priority
Provides driver mobile application features for route guidance, collection confirmation, and vehicle status reporting.
*Priority:* High (*H*).

=== Stimulus/Response Sequences
- *Stimulus:* Driver logs into mobile tablet app at start of shift.
- *Response:* App downloads assigned collection manifest, initializes GPS tracking, and opens turn-by-turn navigation overlay.

=== Detailed Functional Requirements
- *FR-5.1 [Waypoint Check-In]:* The system shall automatically register bin collection completion when the driver's vehicle remains within 15 meters of a target bin for at least 45 seconds.
- *FR-5.2 [Manual Collection Overrides]:* The driver app shall allow manual completion logging accompanied by optional photo proof if automated check-in fails.
- *FR-5.3 [Obstacle & Issue Reporting]:* The driver app shall allow reporting of road blockages, blocked bins, or damaged containers directly from the navigation screen.
- *FR-5.4 [Offline Syncing]:* The driver app shall store collection logs in local SQLite storage during network dead-zones and synchronize with cloud servers upon reconnecting.

#pagebreak(weak: true)

== System Feature 6: Municipal Analytics & Sustainability Dashboard

=== Description and Priority
Comprehensive analytics interface for city administrators to monitor performance metrics, operational costs, and environmental impact.
*Priority:* High (*H*).

=== Stimulus/Response Sequences
- *Stimulus:* Administrator selects time range (Daily, Weekly, Monthly) on dashboard.
- *Response:* System calculates aggregated metrics, renders interactive trend graphs, and updates GIS sector heatmaps.

=== Detailed Functional Requirements
- *FR-6.1 [Real-Time GIS Heatmap]:* The system shall render an interactive vector map depicting color-coded bin statuses (Green: below 50%, Yellow: 50% to 84%, Red: 85% or above, Black: Faulty).
- *FR-6.2 [Fleet Efficiency Tracking]:* The system shall track and compute fuel consumption, kilometers traveled per ton of waste collected, and driver idle time.
- *FR-6.3 [Carbon Reduction Computation]:* The system shall calculate estimated fuel savings and CO2 emissions avoided from route optimization (using a conversion factor of 2.68 kg CO2 per liter of diesel).
- *FR-6.4 [Automated Executive Reporting]:* The system shall generate scheduled weekly PDF executive summary reports sent via email to department heads.
- *FR-6.5 [Data Exporting]:* The system shall export historical telemetry and collection logs in CSV, JSON, and Excel formats.

== System Feature 7: User Authentication & Role-Based Access Control

=== Description and Priority
Ensures secure multi-tenant identity verification, session management, and granular role permissions.
*Priority:* High (*H*).

=== Stimulus/Response Sequences
- *Stimulus:* User submits login credentials or auth token.
- *Response:* System authenticates identity, returns signed JWT access token, and grants access matching designated user role permissions.

=== Detailed Functional Requirements
- *FR-7.1 [Multi-Factor Authentication]:* The system shall support secure SMS/Email OTP two-factor authentication for administrative accounts.
- *FR-7.2 [Role-Based Authorization (RBAC)]:* The system shall strictly enforce permission matrices restricting API routes and data access according to user roles (`CITIZEN`, `DRIVER`, `ADMIN`, `ENGINEER`).
- *FR-7.3 [Session Expiration]:* JWT access tokens shall expire after 60 minutes of inactivity, requiring seamless refresh token exchange.
- *FR-7.4 [Audit Logging]:* The system shall record all administrative actions, threshold changes, and manual overrides in an immutable system audit log.

#pagebreak(weak: true)

= Other Nonfunctional Requirements

== Performance Requirements
- *Response Time:* Web dashboard pages must achieve First Contentful Paint (FCP) in under 1.2 seconds and Interactive state (TTI) in under 2.5 seconds.
- *API Throughput:* Backend API gateways shall handle a minimum of 2,500 concurrent REST requests per second without degradation.
- *Database Query Speed:* Spatial proximity queries across 50,000 bin locations shall execute in under 50 ms.

== Safety Requirements
- *Hazard Mitigation:* In the event of detected methane gas buildup or fire condition in a bin, the system shall broadcast high-priority visual and audio alerts to the nearest dispatch station.
- *Driver Safety Lockout:* The driver mobile application shall disable text input capabilities while vehicle speed exceeds 10 km/h.

== Security Requirements
- *Data Encryption:* All network communications must mandate TLS 1.3 encryption. Telemetry data at rest in databases shall be encrypted using AES-256.
- *Password Security:* User passwords must be salted and hashed using Argon2id or bcrypt (12 rounds) prior to storage.
- *API Protection:* API endpoints shall implement rate-limiting caps of 100 requests per minute per IP address to prevent Denial of Service (DoS) attacks.

== Software Quality Attributes
- *Availability:* System target uptime shall be 99.9% (less than 8.76 hours unplanned downtime per year).
- *Maintainability:* Source code shall maintain modular separation of concerns, achieving at least 85% automated unit test coverage.
- *Usability:* Interface designs shall conform to Web Content Accessibility Guidelines (WCAG 2.1 Level AA).

== Business Rules
- *Collection Operational Window:* Route optimization algorithms shall restrict scheduled urban residential collections between 06:00 and 22:00 hours.
- *Sensor Calibration Protocol:* Any bin reporting identical fill readings continuously for 72 hours shall automatically be flagged for hardware sensor re-calibration.

#pagebreak(weak: true)

= Database & Data Integrity Requirements

== Entity Relationship Specification
The core data architecture relies on relational schema definitions supporting spatial indexing and real-time document synchronization.

#responsive-image("attachments/er_diagram.svg", width: 100%)

== Data Models & Integrity Constraints
1. *SmartBin Document Constraints:* `bin_id` must be unique string UUID; `fill_level_pct` constrained between 0.0% and 100.0%.
2. *TelemetryLog Constraints:* Foreign key constraint on `bin_id`; `recorded_at` indexed in descending order for temporal range queries.
3. *IncidentReport Constraints:* Geo-coordinates must fall within valid municipal boundaries (18.90° to 19.30° N, 72.75° to 73.00° E).

#pagebreak(weak: true)

= Appendix A: Glossary & Terminology

#styled-table(
  columns: (1.2fr, 2.8fr),
  headers: ("Term / Acronym", "Formal Definition & Context"),
  "SWMS", "Smart Waste Management System — The comprehensive urban software and hardware platform specified herein.",
  "IoT", "Internet of Things — Network of physical objects embedded with sensors, software, and connectivity.",
  "MQTT", "Message Queuing Telemetry Transport — Lightweight publish-subscribe network protocol designed for constrained devices.",
  "GPS", "Global Positioning System — Satellite-based radionavigation system providing location and time information.",
  "GeoJSON", "An open standard format designed for representing simple geographical features along with their non-spatial attributes.",
  "FCP / TTI", "First Contentful Paint / Time to Interactive — Core Web Vitals user interface responsiveness performance metrics.",
  "RBAC", "Role-Based Access Control — Security approach restricting system access to authorized user roles."
)

= Appendix B: System Use Case Overview

The high-level interaction between primary actors (Citizen, IoT Gateway, Collection Driver, Municipal Admin) and core system boundaries is modeled below:

#responsive-image("attachments/use_case_diagram.svg", width: 100%)

= Appendix C: To Be Determined (TBD) List

#styled-table(
  columns: (0.8fr, 2.2fr, 1fr),
  headers: ("Item ID", "Description of Open Requirement", "Target Closure Date"),
  "TBD-1", "Specification of LoRaWAN fallback protocol parameters for rural sector bins.", "Sprint 4 Review",
  "TBD-2", "Integration API specs for third-party municipal weighbridge hardware scales.", "Sprint 5 Review"
)
