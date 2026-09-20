// ==============================================================================
// ROOMIESYNC — COMPREHENSIVE ARCHITECTURAL & SYSTEM DIAGRAM SUITE
// ==============================================================================
// Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Domain: Student & Young Professional Housing, Real-Time Compatibility Matching
// Tech Stack: React 19, Node.js 20, Express, MongoDB 7.0, Socket.IO, Docker
// Modeling Standard: UML 2.5 & IEEE Std 830-1998 Aligned
// ==============================================================================

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border per GEMINI.md Rule 1
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  )
)

#set text(
  font: ("Times New Roman", "Liberation Serif", "Nimbus Roman", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

#show heading.where(level: 1): set text(size: 16pt, weight: "bold")
#show heading.where(level: 2): set text(size: 14pt, weight: "bold")
#show heading.where(level: 3): set text(size: 13pt, weight: "bold")

// Mandatory: Every Level 1 Heading starts on a new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

// Custom Helper for Consistent Portrait Diagram Sizing
#let portrait-diagram(path, caption-text, desc-block) = [
  #align(center)[
    #block(height: 72%, [
      #image(path, height: 100%, fit: "contain")
    ])
    #v(0.3em)
    #text(size: 10.5pt, weight: "bold")[#caption-text]
  ]
  #v(0.4em)
  #desc-block
]

// Custom Helper for Consistent Landscape Diagram Sizing
#let landscape-diagram(path, caption-text, desc-block) = [
  #align(center)[
    #block(height: 55%, [
      #image(path, width: 100%, fit: "contain")
    ])
    #v(0.3em)
    #text(size: 10.5pt, weight: "bold")[#caption-text]
  ]
  #v(0.4em)
  #desc-block
]

// ==============================================================================
// TITLE PAGE
// ==============================================================================
#align(center)[
  #v(2cm)
  #text(size: 22pt, weight: "bold")[ROOMIESYNC PLATFORM]
  
  #v(0.5cm)
  #text(size: 14pt, weight: "medium", style: "italic")[Comprehensive Architectural, UML & System Process Model Suite]

  #v(1cm)
  #line(length: 60%, stroke: 1.5pt + black)
  #v(1cm)

  #text(size: 11.5pt)[
    *Course:* JUSIT-DSCPR503 --- Project Dissertation and Implementation \
    *Domain:* Smart Housing, Collaborative Tenancy & Algorithmic Roommate Matching \
    *Technology Stack:* React 19 SPA, Express.js (Node.js 20), MongoDB 7.0, Socket.IO \
    *Containerization:* Docker Engine & Docker Compose (`roomiesync-net`) \
    *Modeling Standard:* UML 2.5, IEEE Std 830-1998, and Modern High-Contrast Vector Standards
  ]

  #v(2.5cm)
  #text(size: 11pt)[
    *Department of Information Technology* \
    *University Examination & Project Submission Test Document*
  ]
]

#pagebreak()

// ==============================================================================
// TABLE OF CONTENTS / OUTLINE
// ==============================================================================
#outline(
  title: [Table of System Diagrams],
  target: heading.where(level: 1),
  indent: 1.5em,
)

// ==============================================================================
// 1. ENTITY-RELATIONSHIP DIAGRAM
// ==============================================================================
= Entity-Relationship Diagram (ERD)

#portrait-diagram(
  "diagrams/er_diagram.svg",
  [Figure 1: Entity-Relationship Diagram (Crow's Foot Notation)],
  [
    *Architectural & Schema Details:*
    - *Crow's Foot Cardinalities:* Models 1:1, 1:N, and M:N relationships across all 12 core collections.
    - *Identity & Profile:* `USERS` $1:1$ `PROFILES`, maintaining decoupled authentication credentials and rich roommate preferences.
    - *Tenancy & Operations:* `PROPERTIES` $1:N$ `AGREEMENTS` with dual roommate co-signing constraints and $1:N$ `EXPENSES` with split shares.
    - *Communication Layer:* `CONVERSATIONS` $1:N$ `MESSAGES` with indexed participant pairs and real-time read telemetry.
  ]
)

// ==============================================================================
// 2. DATABASE SCHEMA
// ==============================================================================
= Physical Database Schema

#portrait-diagram(
  "diagrams/database_schema.svg",
  [Figure 2: Physical Database Schema (MongoDB 7.0 Collections & Indexes)],
  [
    *Index & Storage Specifications:*
    - *Indexed Primary Keys:* Explicit UUID string identifiers indexed across all 12 collections (`_id: String [INDEX]`).
    - *Compound & Unique Indexes:* Unique constraint on `FriendRequest` `{senderId, recipientId}` to prevent duplicate matches; compound index `{conversationId, createdAt}` on `Message` for low-latency pagination.
    - *Foreign Key References:* Strict logical references enforcing relational integrity across un-sharded MongoDB document collections.
  ]
)

// ==============================================================================
// 3. CLASS DIAGRAM
// ==============================================================================
= Domain Class Diagram

#portrait-diagram(
  "diagrams/class_diagram.svg",
  [Figure 3: Domain Class Hierarchy & Backend Services],
  [
    *Class Hierarchy & Service Layers:*
    - *Presentation & API:* `ApiService` encapsulating REST communication with Axios and Bearer JWT authorization.
    - *Matching & Automation:* `MatchingEngine` computing multi-dimensional compatibility vectors; `PDFGenerator` rendering legally binding tenancy agreements.
    - *Data Models:* Complete Mongoose model representations with typed attributes and schema instance methods.
  ]
)

// ==============================================================================
// 4. OBJECT DIAGRAM
// ==============================================================================
= Runtime Object Diagram

#portrait-diagram(
  "diagrams/object_diagram.svg",
  [Figure 4: Concrete Runtime Object Snapshot (Seed Data Graph)],
  [
    *Runtime Instance State (`seedData.js`):*
    - *User & Profile:* Concrete instances `usr_1` (Aarav Sharma) and `usr_2` (Ananya Verma) with active profile configurations.
    - *Social & Tenancy:* Accepted friend request `req_101`, 3BHK flat listing `prop_1`, and active co-signed tenancy agreement `agr_1`.
    - *Ledger & Review:* Shared WiFi expense `exp_2` (₹1,499 split 50/50) and verified 5-star landlord review `rev_1`.
  ]
)

// ==============================================================================
// 5. PACKAGE DIAGRAM
// ==============================================================================
= Package Architecture Diagram

#portrait-diagram(
  "diagrams/package_diagram.svg",
  [Figure 5: Layered Subsystem Package Architecture],
  [
    *Package Modularization:*
    - *Presentation Layer:* React 19 Single Page Application, component hierarchy, and client-side view routers.
    - *API & Routing:* Express REST route handlers and JWT authentication security middleware.
    - *Business Logic & Data Access:* Domain controllers, matching services, PDF generation pipelines, and Mongoose ODM models.
  ]
)

// ==============================================================================
// 6. USE CASE DIAGRAM
// ==============================================================================
= System Use Case Diagram

#portrait-diagram(
  "diagrams/use_case_diagram.svg",
  [Figure 6: System Use Case Model with Actor Subsystem Partitioning],
  [
    *Actor Boundaries & Interactions:*
    - *Roommate / Tenant:* Profile discovery, lifestyle matching, real-time chat, expense splitting, and meal subscription.
    - *Property Landlord:* Flat listing creation, inspection scheduling, KYC verification, and digital lease countersigning.
    - *Platform Administrator:* User verification, moderation dispute triage, and audit log inspection.
  ]
)

// ==============================================================================
// 7. ACTIVITY DIAGRAM
// ==============================================================================
= Activity Diagram: Tenancy & Agreement Workflow

#portrait-diagram(
  "diagrams/activity_diagram.svg",
  [Figure 7: Swimlane Activity Diagram for Booking & Digital Agreement Flow],
  [
    *Multi-Party Workflow across Swimlanes:*
    - *Tenant:* Schedule property physical inspection, inspect premises, and initiate joint tenancy proposal.
    - *RoomieSync Platform:* Generate digital PDF agreement draft, compute equal deposit quotas, and collect dual signatures.
    - *Landlord:* Review tenant KYC credentials, countersign agreement, and authorize move-in access.
  ]
)

// ==============================================================================
// 8. SEQUENCE DIAGRAM
// ==============================================================================
= Sequence Diagram: Real-Time Chat & Read Receipts

#portrait-diagram(
  "diagrams/sequence_diagram.svg",
  [Figure 8: Sequence Diagram for Socket.IO Duplex Messaging],
  [
    *Event Tracing & Telemetry:*
    - *Message Dispatch:* Client emits `send_message` payload over persistent WebSocket connection to Socket.IO gateway.
    - *Persistence & Acknowledgement:* Gateway persists document in MongoDB `messages` collection and updates conversation timestamp.
    - *Read Receipt Lifecycle:* Recipient view triggers `message_read` event, persisting `readAt` timestamp and emitting blue-tick visual acknowledgement.
  ]
)

// ==============================================================================
// 9. STATE MACHINE DIAGRAM
// ==============================================================================
= State Machine Diagram: Rental Agreement Lifecycle

#portrait-diagram(
  "diagrams/state_diagram.svg",
  [Figure 9: State Transition Machine for Rental Agreement Execution],
  [
    *State Transitions & Quorum Rules:*
    - `Draft` $-->$ `PartiallySigned`: First roommate completes digital signature execution.
    - `PartiallySigned` $-->$ `AwaitingLandlord`: Second roommate signs; lease enters landlord escrow queue.
    - `AwaitingLandlord` $-->$ `ApprovedAndSigned`: Landlord validates deposit & countersigns; activates expense ledger.
    - `ApprovedAndSigned` $-->$ `Terminated`: Lease period concludes; security deposit is reconciled and refunded.
  ]
)

// ==============================================================================
// 10. DATA FLOW DIAGRAM (LEVEL 0)
// ==============================================================================
= Context-Level Data Flow Diagram (DFD Level 0)

#portrait-diagram(
  "diagrams/dfd_level_0.svg",
  [Figure 10: Context-Level Data Flow Diagram (DFD Level 0)],
  [
    *Context Boundary Data Flows:*
    - *External Entities:* Interacts with Roommate / User, Property Landlord, Mess Service Provider, and System Administrator.
    - *Inbound Transactions:* Compatibility survey responses, lease sign events, expense receipts, and property listings.
    - *Outbound Telemetry:* Recommended roommate rankings, digital lease PDF contracts, shared expense summaries, and system moderation reports.
  ]
)

// ==============================================================================
// 11. DATA FLOW DIAGRAM (LEVEL 1)
// ==============================================================================
= Functional Decomposition Data Flow Diagram (DFD Level 1)

#portrait-diagram(
  "diagrams/dfd_level_1.svg",
  [Figure 11: System Functional Decomposition (Level 1) with Data Stores],
  [
    *Core Functional Decomposition:*
    - *Processes 1.0–3.0:* Profile Management, Matching Engine calculation, and Property Search & Booking.
    - *Processes 4.0–6.0:* Real-Time Chat Gateway, Agreement & Digital Signing, and Shared Expense Tracker.
    - *Data Stores:* Read/write coordination across `D1: Users`, `D2: Properties`, `D3: Messages`, `D4: Agreements`, `D5: Expenses`, and `D6: Meal Plans`.
  ]
)

// ==============================================================================
// 12. DATA FLOW DIAGRAM (LEVEL 2)
// ==============================================================================
= Subsystem Data Flow Diagram (DFD Level 2: Chat Engine)

#portrait-diagram(
  "diagrams/dfd_level_2.svg",
  [Figure 12: Real-Time Chat & Socket.IO Subsystem Decomposition (Level 2)],
  [
    *Subsystem Process Execution:*
    - *Process 4.1:* Socket connection authentication and Bearer JWT handshake verification.
    - *Process 4.2 & 4.3:* Inbound message payload sanitization, MongoDB message persistence, and broadcast dispatch.
    - *Process 4.4:* Read receipt timestamping and bidirectional duplex sync across connected room participant sockets.
  ]
)

// ==============================================================================
// 13. COMPONENT DIAGRAM
// ==============================================================================
= Component-Based Software Architecture Diagram

#portrait-diagram(
  "diagrams/component_diagram.svg",
  [Figure 13: 3-Tier Enterprise Component Diagram],
  [
    *Tier Interconnections:*
    - *Presentation Tier:* React 19 Single Page App, Socket.IO client, and Vite-bundled Tailwind CSS interface.
    - *Application Tier:* Express REST API router, Socket.IO WebSocket gateway, Lifestyle Matching Engine, and PDF Agreement Service.
    - *Data & Storage Tier:* MongoDB 7.0 database engine with 12 collections and Cloudinary external media storage.
  ]
)

// ==============================================================================
// 14. DEPLOYMENT DIAGRAM
// ==============================================================================
= Deployment Topology Diagram

#portrait-diagram(
  "diagrams/deployment_diagram.svg",
  [Figure 14: Docker Containerization & Cloud Host Deployment Topology],
  [
    *Infrastructure Configuration (`docker-compose.yml`):*
    - *Docker Host:* Ubuntu Linux virtual machine hosting isolated bridge network `roomiesync-net`.
    - *Containers:* `roomiesync-frontend` (Nginx Alpine, Port 3000), `roomiesync-backend` (Node.js 20, Port 5000), and `roomiesync-mongodb` (Mongo 7.0, Port 27017).
    - *Storage & Media:* Persistent named volume `mongodb_data` and HTTPS integration with Cloudinary CDN.
  ]
)

// ==============================================================================
// 15. PERT / CPM CHART
// ==============================================================================
= Project Scheduling: PERT / CPM Chart

#portrait-diagram(
  "diagrams/pert_chart.svg",
  [Figure 15: Critical Path Method (CPM) Network Diagram],
  [
    *Project Scheduling & Critical Path:*
    - *Critical Path:* Identified through nodes `A -> B -> D -> F -> G` representing Requirements, Architecture, Backend Core, Matching Engine, and Integration Testing.
    - *Total Project Duration:* 28 calendar days with explicit early start ($E S$), early finish ($E F$), late start ($L S$), and late finish ($L F$) variance metrics.
  ]
)

// ==============================================================================
// 16. GANTT CHART
// ==============================================================================
= Project Execution: Gantt Schedule

#landscape-diagram(
  "diagrams/gantt_chart.svg",
  [Figure 16: Project Execution Gantt Schedule],
  [
    *Milestone Timelines:*
    - *Sprint 1:* Requirements Analysis & Data Modeling (Days 1–5).
    - *Sprint 2:* Backend Express REST APIs & Authentication (Days 6–13).
    - *Sprint 3:* React 19 Frontend & Matching Engine UI (Days 10–19).
    - *Sprint 4:* Socket.IO Real-time Messaging & PDF Signing (Days 18–24).
    - *Sprint 5:* Integration Testing, Dockerization & Deployment (Days 23–28).
  ]
)

// ==============================================================================
// 17. EVENT-RESPONSE TRACEABILITY MATRIX
// ==============================================================================
= Event-Response Traceability Matrix

#landscape-diagram(
  "diagrams/event_table.svg",
  [Figure 17: System Event-Response Traceability Matrix],
  [
    *Traceability Analysis:*
    - Maps incoming user actions (`EVT-01` to `EVT-06`) across authentication, roommate matching, flat booking, and real-time messaging directly to their corresponding backend controllers, database queries, and response payloads.
  ]
)
