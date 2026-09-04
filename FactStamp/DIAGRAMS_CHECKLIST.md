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
    USER ||--o{ CLAIM : "submits (0..N)"
    USER ||--o{ VERIFICATION : "casts (0..N)"
    CLAIM ||--o{ VERIFICATION : "receives (0..N)"
    CLAIM ||--o{ DUPLICATE_CLUSTER : "groups (0..N)"
    CLAIM }o--|| CATEGORY_METRIC : "aggregates into (N..1)"

    USER {
        string uid PK
        string displayName
        string email
        int reputation
        int totalVerifications
        boolean isAdmin
        timestamp joinedAt
    }

    CLAIM {
        string id PK
        string text
        string mediaUrl
        string status
        string verdict
        float confidence
        string category
        string submittedBy FK
        timestamp submittedAt
        int quorumCount
        timestamp lastVerifiedAt
    }

    VERIFICATION {
        string id PK
        string claimId FK
        string verifierId FK
        string verifierName
        int verifierReputation
        string verdict
        string sourceUrl
        string rationale
        int sourceCredibility
        timestamp votedAt
    }

    DUPLICATE_CLUSTER {
        string id PK
        string canonicalClaimId FK
        string duplicateText
        float jaccardScore
        timestamp detectedAt
    }

    CATEGORY_METRIC {
        string category PK
        int totalClaims
        int verifiedCount
        int contestedCount
        timestamp lastUpdated
    }
```

---

### 2. PlantUML Source Code (`er_diagram.puml`)

```plantuml
@startuml
skinparam style strictuml
skinparam monochrome true
skinparam defaultFontName "Liberation Sans"
skinparam defaultFontSize 14
skinparam defaultFontStyle bold
skinparam titleFontSize 20
skinparam titleFontStyle bold

skinparam backgroundColor white
skinparam ArrowColor black
skinparam ArrowThickness 2.5
skinparam ArrowFontSize 13
skinparam ArrowFontStyle bold

skinparam ClassBorderColor black
skinparam ClassBorderThickness 2.5
skinparam ClassBackgroundColor #F8F9FA
skinparam ClassFontSize 14
skinparam ClassFontStyle bold

title FactStamp - Entity-Relationship (E-R) Diagram

entity "USER" as User {
  * uid : string [PK]
  --
  * displayName : string
  * email : string
  * reputation : integer [0..100]
  * totalVerifications : integer
  * isAdmin : boolean
  * joinedAt : timestamp
}

entity "CLAIM" as Claim {
  * id : string [PK]
  --
  * text : string (normalized)
  mediaUrl : string (optional)
  * status : string (enum)
  verdict : string (enum)
  confidence : float [0.0..100.0]
  * category : string (enum)
  submittedBy : string [FK: User.uid / "anonymous"]
  * submittedAt : timestamp
  * quorumCount : integer
  lastVerifiedAt : timestamp
}

entity "VERIFICATION" as Verification {
  * id : string [PK]
  --
  * claimId : string [FK: Claim.id]
  * verifierId : string [FK: User.uid]
  * verifierName : string
  * verifierReputation : integer
  * verdict : string (enum)
  * sourceUrl : string
  * rationale : string
  * sourceCredibility : integer
  * votedAt : timestamp
}

entity "DUPLICATE_CLUSTER" as DuplicateCluster {
  * id : string [PK]
  --
  * canonicalClaimId : string [FK: Claim.id]
  * duplicateText : string
  * jaccardScore : float [0.75..1.00]
  * detectedAt : timestamp
}

entity "CATEGORY_METRIC" as CategoryMetric {
  * category : string [PK]
  --
  * totalClaims : integer
  * verifiedCount : integer
  * contestedCount : integer
  * lastUpdated : timestamp
}

User ||--o{ Claim : "submits (0..N)"
User ||--o{ Verification : "casts (0..N)"
Claim ||--o{ Verification : "receives (0..N)"
Claim ||--o{ DuplicateCluster : "groups (0..N)"
Claim }o--|| CategoryMetric : "aggregates into (N..1)"

@enduml
```

---

### 3. Entity & Relationship Cardinality Matrix

| Parent Entity | Relationship | Child Entity | Cardinality | Business Logic Rule |
|:---|:---:|:---|:---:|:---|
| **User** | Submits | **Claim** | $1 : N$ (Optional) | A registered or anonymous user can submit zero or many claims for verification. |
| **User** | Casts | **Verification** | $1 : N$ (Optional) | Community verifiers can submit evaluation votes and source citations across claims. |
| **Claim** | Receives | **Verification** | $1 : N$ (Mandatory $\ge 3$) | A claim requires at least 3 independent verifications to achieve quorum consensus. |
| **Claim** | Groups | **DuplicateCluster** | $1 : N$ (Optional) | Incoming forwards matching $J(A, B) \ge 0.75$ are clustered under the canonical claim. |
| **Claim** | Aggregates into | **CategoryMetric** | $N : 1$ (Many-to-One) | Claims roll up into category aggregations (Health, Political, Religious, Financial). |
