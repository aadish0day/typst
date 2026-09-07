// ==============================================================================
// ZAWER LUXURY JEWELLERY PLATFORM — ARCHITECTURAL & UML DIAGRAM SUITE
// ==============================================================================
// Academic Course: JUSIT-DSCPR503 (Project Dissertation and Implementation)
// Candidate: Aadish Das | UID: 24BIT010 / 2023IT001 | Roll No: 10
// Institution: Jai Hind College (Empowered Autonomous), University of Mumbai
// ==============================================================================

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
  // Mandatory Black Page Border
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

#show heading.where(level: 1): set text(size: 15pt, weight: "bold")
#show heading.where(level: 2): set text(size: 13pt, weight: "bold")
#show heading.where(level: 3): set text(size: 11.5pt, weight: "bold")

// Mandatory: New topic / diagram on new page
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  it
}

#align(center)[
  #v(2cm)
  #text(size: 22pt, weight: "bold")[ZAWER LUXURY JEWELLERY PLATFORM]
  
  #v(0.5cm)
  #text(size: 15pt, weight: "medium", style: "italic")[Comprehensive Architectural, UML & Process Diagram Suite]

  #v(1cm)
  #line(length: 60%, stroke: 1.5pt + black)
  #v(1cm)

  #text(size: 12pt)[
    *Course:* JUSIT-DSCPR503 --- Project Dissertation and Implementation \
    *Domain:* E-Commerce, Distributed Systems & Luxury Vault Logistics \
    *Technology Stack:* Flutter 3.x, Express.js (Node.js 20), MongoDB 7.0, Docker \
    *Modeling Standard:* UML 2.5 & IEEE Std 830-1998 Aligned
  ]

  #v(2cm)
  #text(size: 11.5pt)[
    *Author:* Aadish Das (Roll No: 10, UID: 24BIT010) \
    *Department of Information Technology* \
    *Jai Hind College (Empowered Autonomous), Mumbai*
  ]
]

#pagebreak()

#outline(
  title: [Table of System Diagrams],
  target: heading.where(level: 1),
  indent: 1.5em,
)

// ==============================================================================
// 1. SYSTEM ARCHITECTURE DIAGRAM
// ==============================================================================
= System Architecture Diagram

#align(center)[
  #figure(
    image("01_system_architecture.svg", width: 95%),
    caption: [High-Level 4-Tier System Architecture of ZAWER Jewellery Platform],
  )
]

#v(0.5em)
*Architectural Overview:*
- *Client Presentation Tier:* Flutter 3.x cross-platform client (Android, iOS, Web via CanvasKit) providing high-end luxury UI with Fraunces serif typography and resilient HTTP auto-retry mechanisms.
- *Ingress & Security Boundary:* Secure HTTPS/TLS 1.3 reverse proxy routing inbound REST traffic to Port 5000 with CORS protection and Bearer JWT authorization.
- *Application Processing Tier:* Containerized Node.js 20 Express service hosting 6 decoupled domain controllers (`auth`, `product`, `cart`, `wishlist`, `order`, `offer`).
- *Persistence & Logistics Tier:* MongoDB 7.0 document store with Mongoose ODM connection pooling, synchronized with Sequel Secure Luxury Logistics external tracking APIs.

// ==============================================================================
// 2. USE CASE DIAGRAM
// ==============================================================================
= System Use Case Diagram

#align(center)[
  #figure(
    image("02_use_case_diagram.svg", width: 95%),
    caption: [Comprehensive Use Case Model of ZAWER Jewellery Platform],
  )
]

#v(0.5em)
*Core Actor Interactions:*
- *Guest User:* Browse certified collections, search by purity (18K/22K), inspect BIS hallmark specifications, and view privilege promotions.
- *Registered Customer (VIP Patron):* Profile management, JWT session maintenance, cart/wishlist management, coupon validation, checkout, and live order tracking.
- *Store Concierge / Vault Admin:* Product catalog administration, offer configuration, 24-point hallmarking inspection, and order lifecycle status advancement.
- *Sequel Logistics Partner:* Serialized tamper-evident packaging, GPS-monitored armored transit, and white-glove hand delivery verification.

// ==============================================================================
// 3. BACKEND CLASS DIAGRAM
// ==============================================================================
= Backend Class Diagram (Mongoose & Express)

#align(center)[
  #figure(
    image("03_backend_class_diagram.svg", width: 95%),
    caption: [Backend Domain Models and Express Controllers Class Hierarchy],
  )
]

#v(0.5em)
*Class Design Specifications:*
- *Domain Models:* `User` (credentials, OTP reset), `Product` (gold purity, pricing, embedded `ReviewSchema`), `Cart` (composite `CartItemSchema`), `Wishlist`, `Offer` (discount formulas, expiry evaluation), and `Order` (monetary calculation, embedded `TimelineStepSchema`).
- *Service Controllers:* Complete REST controller methods implementing atomic CRUD operations, coupon validation mathematics, and 6-stage milestone transitions.

// ==============================================================================
// 4. FRONTEND CLASS DIAGRAM
// ==============================================================================
= Frontend Class Diagram (Flutter & Dart)

#align(center)[
  #figure(
    image("04_frontend_class_diagram.svg", width: 95%),
    caption: [Flutter Client Architecture, Service Adapters, and UI Controllers],
  )
]

#v(0.5em)
*Frontend Model Specifications:*
- *Client Networking:* `ApiService` encapsulating 24+ static asynchronous methods with a 3-tier auto-retry loop and Bearer token header injection.
- *Data Contracts:* `Product`, `OrderTrackingModel`, `OrderItemModel`, `TrackingStep`, and `OfferModel` with robust JSON serialization (`fromJson` / `toJson`).
- *Presentation Layer:* Coordinated screen hierarchy orchestrated by `ThemeController` and `AppTheme`.

// ==============================================================================
// 5. ENTITY-RELATIONSHIP DIAGRAM
// ==============================================================================
= Entity-Relationship Diagram (Crow's-Foot Notation)

#align(center)[
  #figure(
    image("05_entity_relationship_diagram.svg", width: 95%),
    caption: [Crow's-Foot Entity-Relationship Schema for MongoDB Collections],
  )
]

#v(0.5em)
*Schema Relationships & Cardinalities:*
- `USERS` $1:0..1$ `CARTS` (One active basket per patron).
- `USERS` $1:0..1$ `WISHLISTS` (One persistent wishlist per patron).
- `USERS` $1:0..N$ `ORDERS` (Historical order records per customer).
- `ORDERS` $1:1..N$ `ORDER_ITEMS` (Embedded line items referencing catalog products).
- `PRODUCTS` $1:0..N$ `PRODUCT_REVIEWS` (Embedded customer verified reviews).
- `OFFERS` $0..1:0..N$ `ORDERS` (Optional promotional coupon applied per checkout).

// ==============================================================================
// 6. DATA FLOW DIAGRAM (LEVEL 0)
// ==============================================================================
= Context-Level Data Flow Diagram (DFD Level 0)

#align(center)[
  #figure(
    image("06_dfd_level_0.svg", width: 95%),
    caption: [Context-Level Data Flow Diagram (DFD Level 0) for ZAWER Central System],
  )
]

#v(0.5em)
*Boundary Data Flows:*
- *Inbound Flows:* Customer credentials, catalog search filters, cart/wishlist mutations, privilege coupon codes, checkout specifications, and tracking inquiries.
- *Outbound Flows:* Signed JWT session tokens, BIS hallmark certifications, live cart updates, calculated promotional discounts, order receipts, and real-time transit telemetry.

// ==============================================================================
// 7. DATA FLOW DIAGRAM (LEVEL 1)
// ==============================================================================
= Functional Decomposition Data Flow Diagram (DFD Level 1)

#align(center)[
  #figure(
    image("07_dfd_level_1.svg", width: 95%),
    caption: [Functional Decomposition Data Flow Diagram (DFD Level 1) with Datastores],
  )
]

#v(0.5em)
*Core Functional Processes:*
- `1.0 Identity & Access Management` (Authentication and token lifecycle via `D1: Users`).
- `2.0 Jewellery Catalog & Search` (Purity filtering and reviews via `D2: Products`).
- `3.0 Cart & Wishlist Synchronization` (Bag persistence via `D3: Carts` and `D4: Wishlists`).
- `4.0 Privilege Offers & Dynamic Pricing` (Coupon validation via `D5: Offers`).
- `5.0 Checkout & Order Processing` (Receipt generation via `D6: Orders`).
- `6.0 Vault Logistics & Milestone Tracking` (Telemetry and courier tracking updates).

// ==============================================================================
// 8. ACTIVITY DIAGRAM: ORDER PLACEMENT FLOW
// ==============================================================================
= Activity Diagram: Customer Order Placement Flow

#align(center)[
  #figure(
    image("08_activity_order_flow.svg", width: 95%),
    caption: [Swimlane Activity Diagram for Customer Order Placement and Checkout],
  )
]

#v(0.5em)
*Process Workflow Across Swimlanes:*
- *Customer / Client:* Catalog browsing, item selection, coupon entry, and payment selection.
- *Flutter App:* Local validation, JWT auth guard, grand total recalculation, and confirmation toast.
- *Express API:* Token verification, coupon verification, atomic stock validation, and order record creation.
- *MongoDB Database:* Persistent transactional updates to `orders`, `carts`, and `offers`.

// ==============================================================================
// 9. ACTIVITY DIAGRAM: LUXURY FULFILLMENT & HALLMARKING
// ==============================================================================
= Activity Diagram: Luxury Fulfillment & Hallmarking Flow

#align(center)[
  #figure(
    image("09_activity_fulfillment_flow.svg", width: 95%),
    caption: [Vault Logistics, 24-Point Hallmarking, and Armored Delivery Workflow],
  )
]

#v(0.5em)
*Fulfillment Milestones:*
- *Vault Intake:* Order registration, item allocation, and certification assignment.
- *Assay Lab Inspection:* 24-point prong setting check, 18K/22K laser hallmarking, and ultrasonic cleaning.
- *Tamper-Evident Packaging:* Dual-barcode serialized security pouch sealing.
- *White-Glove Delivery:* Sequel Secure armored transit, Govt ID check, seal inspection, and hand delivery.

// ==============================================================================
// 10. STATE MACHINE DIAGRAM: ORDER LIFECYCLE
// ==============================================================================
= State Machine Diagram: Order Lifecycle

#align(center)[
  #figure(
    image("10_state_order_lifecycle.svg", width: 95%),
    caption: [Order Lifecycle State Machine with Guard Conditions and Actions],
  )
]

#v(0.5em)
*Lifecycle State Progression:*
- `Order Placed` $-->$ `Order Confirmed` (Payment authorization and vault reservation).
- `Order Confirmed` $-->$ `Processing & Hallmarking` (24-point artisan and gemological inspection).
- `Processing` $-->$ `Shipped & Dispatched` (Tamper-evident sealing and handover to Sequel Logistics).
- `Shipped` $-->$ `Out for Delivery` (Sector hub arrival and courier assignment).
- `Out for Delivery` $-->$ `Delivered` (Government ID verification and presentation box handover).
- Alternative Path: `Cancelled` (Automated inventory deallocation and refund queue trigger).

// ==============================================================================
// 11. SEQUENCE DIAGRAM: AUTHENTICATION & JWT FLOW
// ==============================================================================
= Sequence Diagram: Authentication & JWT Session Flow

#align(center)[
  #figure(
    image("11_sequence_auth_flow.svg", width: 95%),
    caption: [User Registration, Bcrypt Verification, JWT Issuance, and Storage Flow],
  )
]

#v(0.5em)
*Key Sequence Steps:*
- Registration with SHA-256 / Bcrypt password hashing (`saltRounds: 10`).
- Login credential verification and RS256 / HMAC JWT token creation (`expiresIn: "7d"`).
- Client-side token caching inside Flutter `SharedPreferences`.
- Automatic `Bearer <token>` authorization injection on all subsequent secured API requests.

// ==============================================================================
// 12. SEQUENCE DIAGRAM: CART & COUPON RECALCULATION
// ==============================================================================
= Sequence Diagram: Cart & Privilege Coupon Validation

#align(center)[
  #figure(
    image("12_sequence_cart_coupon_flow.svg", width: 95%),
    caption: [Dynamic Coupon Code Validation, Discount Calculation, and Total Adjustment],
  )
]

#v(0.5em)
*Validation & Computation Rules:*
- 7-step server validation: existence, active status, start/end validity window, usage limit, minimum purchase threshold, and applicable jewellery category.
- Dynamic calculation: Percentage or flat discount computation capped by `maxDiscount`.
- Real-time client total adjustment with visual gold badge confirmation.

// ==============================================================================
// 13. SEQUENCE DIAGRAM: ORDER CHECKOUT & PLACEMENT
// ==============================================================================
= Sequence Diagram: Order Checkout & Placement Flow

#align(center)[
  #figure(
    image("13_sequence_order_placement_flow.svg", width: 95%),
    caption: [Checkout Submission, Tracking ID Generation, and Timeline Initialization],
  )
]

#v(0.5em)
*End-to-End Execution:*
- Order submission with item specifications, delivery address, and payment method.
- Re-verification of coupon discount, unique tracking number assignment (`ZWR-XXXXXX`), and 6-stage timeline step initialization.
- Atomic cart wipeout (`DELETE /api/cart`) and redirection to live tracking view.

// ==============================================================================
// 14. COMPONENT DIAGRAM (CBSE)
// ==============================================================================
= Component Diagram (CBSE Architecture)

#align(center)[
  #figure(
    image("14_component_diagram.svg", width: 95%),
    caption: [Component-Based Software Engineering Diagram with Interfaces and Ports],
  )
]

#v(0.5em)
*Component Decoupling:*
- Presentation components interacting with `ApiService` via clean Dart interfaces.
- Express API gateway exposing REST endpoints consumed through HTTP/REST over TLS.
- Modular business logic components (`AuthComp`, `ProductComp`, `CartComp`, `OrderComp`, `OfferComp`) interfacing with Mongoose DAOs and MongoDB.

// ==============================================================================
// 15. DEPLOYMENT DIAGRAM
// ==============================================================================
= Deployment Diagram (Hardware & Cloud Topology)

#align(center)[
  #figure(
    image("15_deployment_diagram.svg", width: 95%),
    caption: [Physical Hardware, Docker Containers, and Network Deployment Topology],
  )
]

#v(0.5em)
*Topological Nodes:*
- *Client Tier:* Mobile smartphone (Android/iOS) running AOT compiled Flutter app; Web client running on CanvasKit.
- *Host Server:* Linux host running Docker Engine with containerized `zawer_backend` (Port 5000) and `zawer_mongo` (Port 27017) linked via isolated bridge network `zawer_network`.
- *External Services:* Sequel Secure Logistics REST API and Cloud MongoDB Atlas cluster over HTTPS Port 443.

// ==============================================================================
// 16. PACKAGE ARCHITECTURE DIAGRAM
// ==============================================================================
= Package Architecture Diagram

#align(center)[
  #figure(
    image("16_package_diagram.svg", width: 95%),
    caption: [Layered Package Architecture for Flutter Client and Express Backend],
  )
]

#v(0.5em)
*Subsystem Packaging:*
- *Flutter Packages:* Layered presentation (`screens`, `widgets`), domain models (`models`), data services (`services`), and foundational utilities (`utils`).
- *Backend Packages:* MVC layered architecture with `routes`, `middleware`, `controllers`, `models`, `config`, and `seed`.

// ==============================================================================
// 17. RUNTIME OBJECT DIAGRAM
// ==============================================================================
= Runtime Object Diagram (Instantiated Order Snapshot)

#align(center)[
  #figure(
    image("17_object_diagram.svg", width: 95%),
    caption: [Concrete Runtime Object Snapshot of Active Order ZWR-482915],
  )
]

#v(0.5em)
*Runtime Instance Snapshot:*
- Instantiated `User` patron (`Aadish R. Shenoy`), active applied `Offer` (`ROYAL20`), purchased luxury `Product` instances (Diamond Pendant Necklace and Classic Gold Band), and root `Order` (`ZWR-482915`).
- Complete chronological traversal of 6 instantiated `TimelineStep` objects tracking real-time status from vault intake to customer destination.
