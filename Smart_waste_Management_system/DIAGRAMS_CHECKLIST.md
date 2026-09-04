# Required Diagrams Checklist — Dissertation & Black Book

Below is the complete, official mapping of all required diagrams, their syllabus section (Course `JUSIT-DSCPR503`), and recommended tooling formats.

| # | Diagram Name | Syllabus Section | Primary Tool / Format |
|---|---|---|---|
| 1 | PERT Chart | Ch 3.3 (Planning & Scheduling) | Typst / Mermaid / Graphviz |
| 2 | GANTT Chart | Ch 3.3 (Planning & Scheduling) | Typst / Mermaid / Image |
| 3 | Data Flow Diagram (DFD) — Level 0 (Context) | Ch 3.6 (Conceptual Models) | Graphviz (.dot → .svg) |
| 4 | Data Flow Diagram (DFD) — Level 1 | Ch 3.6 (Conceptual Models) | Graphviz (.dot → .svg) |
| 5 | Data Flow Diagram (DFD) — Level 2 | Ch 3.6 (Conceptual Models) | Graphviz (.dot → .svg) |
| 6 | Use Case Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 7 | Activity Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 8 | State Diagram (State Machine) | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 9 | Sequence Diagram | Ch 3.6 (Conceptual Models) | Typst Fletcher / PlantUML |
| 10 | Class Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 11 | Object Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 12 | Package Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 13 | Deployment Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 14 | Component Diagram | Ch 3.6 (Conceptual Models) | PlantUML (.puml → .svg) |
| 15 | **Entity-Relationship (E-R) Diagram** | **Ch 3.6 (Conceptual Models) & Ch 4.2 (Data Design)** | **PlantUML (.puml → .svg)** |
| 16 | UI Wireframes & Screen Layouts | Ch 4.3 & Ch 6.1 (UI & Manual) | SVG / High-Res Mockups |
| 17 | Overall System Architecture Diagram | Ch 5.1 (Implementation Approach) | PlantUML / Mermaid / SVG |

---

## Entity-Relationship (E-R) Diagram

The **Entity-Relationship Diagram** is required under **Chapter 3.6 (Conceptual Models)** as a conceptual data model, and under **Chapter 4.2 (Data Design: Database & Schema Design)** as the formal relational schema design.

### 1. Visual E-R Diagram (Mermaid)

```mermaid
erDiagram
    SmartBin ||--o{ TelemetryLog : "generates (1:N)"
    SmartBin ||--o{ WasteLog : "collected in (1:N)"
    CollectionRoute ||--o{ WasteLog : "includes (1:N)"
    IncidentReport }|--|| SmartBin : "associated with (N:1)"

    SmartBin {
        string bin_id PK
        float location_lat
        float location_lng
        int capacity_liters
        float fill_level_pct
        string status
        timestamp last_updated
    }

    TelemetryLog {
        string log_id PK
        string bin_id FK
        float fill_level
        float battery_level
        float temperature
        timestamp recorded_at
    }

    IncidentReport {
        string report_id PK
        string citizen_uid FK
        string image_url
        string ai_waste_category
        float geo_lat
        float geo_lng
        string status
        timestamp created_at
    }

    CollectionRoute {
        string route_id PK
        string driver_uid FK
        string vehicle_id
        list target_bin_ids
        float total_distance_km
        string route_status
        timestamp assigned_at
    }

    WasteLog {
        string log_id PK
        string route_id FK
        string bin_id FK
        float weight_kg
        timestamp collected_at
    }
```

---

### 2. PlantUML Source Code (`er_diagram.puml`)

```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 18
skinparam defaultFontStyle bold
skinparam titleFontSize 24
skinparam titleFontStyle bold
skinparam EntityFontSize 20
skinparam EntityFontStyle bold
skinparam ClassAttributeFontSize 16
skinparam ArrowThickness 2.5
skinparam EntityBorderThickness 2.5

title Smart Waste Management System - Entity Relationship Diagram

entity SmartBin {
  * bin_id : string <<PK>>
  --
  location_lat : float
  location_lng : float
  capacity_liters : int
  fill_level_pct : float
  status : string
  last_updated : timestamp
}

entity TelemetryLog {
  * log_id : string <<PK>>
  --
  bin_id : string <<FK>>
  fill_level : float
  battery_level : float
  temperature : float
  recorded_at : timestamp
}

entity IncidentReport {
  * report_id : string <<PK>>
  --
  citizen_uid : string <<FK>>
  image_url : string
  ai_waste_category : string
  geo_lat : float
  geo_lng : float
  status : string
  created_at : timestamp
}

entity CollectionRoute {
  * route_id : string <<PK>>
  --
  driver_uid : string <<FK>>
  vehicle_id : string
  target_bin_ids : list<string>
  total_distance_km : float
  route_status : string
  assigned_at : timestamp
}

entity WasteLog {
  * log_id : string <<PK>>
  --
  route_id : string <<FK>>
  bin_id : string <<FK>>
  weight_kg : float
  collected_at : timestamp
}

SmartBin ||--o{ TelemetryLog : "generates"
SmartBin ||--o{ WasteLog : "collected in"
CollectionRoute ||--o{ WasteLog : "includes"
IncidentReport }|--|| SmartBin : "associated with"
@enduml
```

---

### 3. Entity & Relationship Cardinality Matrix

| Parent Entity | Relationship | Child Entity | Cardinality | Business Logic Rule |
|:---|:---:|:---|:---:|:---|
| **SmartBin** | Generates | **TelemetryLog** | $1 : N$ (One-to-Many) | Each smart bin emits periodic ultrasonic sensor telemetry readings over time. |
| **SmartBin** | Collected In | **WasteLog** | $1 : N$ (One-to-Many) | A bin is emptied across multiple dispatch collections over its lifetime. |
| **CollectionRoute** | Includes | **WasteLog** | $1 : N$ (One-to-Many) | Each optimized driver collection route covers multiple designated waste pick-up logs. |
| **IncidentReport** | Associated With | **SmartBin** | $N : 1$ (Many-to-One) | Citizens can report overflow incidents or damaged bins tied to a specific physical bin location. |
