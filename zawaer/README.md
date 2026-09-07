# ZAWER Luxury Jewellery Platform — Architectural & UML Diagram Suite

Comprehensive architectural, structural, behavioral, and process modeling suite for the **ZAWER Luxury Jewellery Platform** (`/home/aadish/Documents/git/zawaer`), covering the Flutter client (`zawer_jewellery_app`) and the containerized Node.js/Express/MongoDB backend (`zawer_backend`).

## Diagram Inventory (17 Diagrams)

| # | Diagram Title | Type | PlantUML (`.puml`) | Vector Graphic (`.svg`) |
|---|---|---|---|---|
| 1 | **System Architecture** | Structural | `01_system_architecture.puml` | `01_system_architecture.svg` |
| 2 | **Use Case Model** | Behavioral | `02_use_case_diagram.puml` | `02_use_case_diagram.svg` |
| 3 | **Backend Class Diagram** | Structural | `03_backend_class_diagram.puml` | `03_backend_class_diagram.svg` |
| 4 | **Frontend Class Diagram** | Structural | `04_frontend_class_diagram.puml` | `04_frontend_class_diagram.svg` |
| 5 | **Entity-Relationship Schema** | Data / ERD | `05_entity_relationship_diagram.puml` | `05_entity_relationship_diagram.svg` |
| 6 | **Data Flow Diagram (Level 0)** | Process | `06_dfd_level_0.puml` | `06_dfd_level_0.svg` |
| 7 | **Data Flow Diagram (Level 1)** | Process | `07_dfd_level_1.puml` | `07_dfd_level_1.svg` |
| 8 | **Order Placement Flow** | Activity | `08_activity_order_flow.puml` | `08_activity_order_flow.svg` |
| 9 | **Fulfillment & Hallmarking** | Activity | `09_activity_fulfillment_flow.puml` | `09_activity_fulfillment_flow.svg` |
| 10 | **Order Lifecycle State Machine** | State | `10_state_order_lifecycle.puml` | `10_state_order_lifecycle.svg` |
| 11 | **Authentication & JWT Flow** | Sequence | `11_sequence_auth_flow.puml` | `11_sequence_auth_flow.svg` |
| 12 | **Cart & Coupon Recalculation** | Sequence | `12_sequence_cart_coupon_flow.puml` | `12_sequence_cart_coupon_flow.svg` |
| 13 | **Checkout & Placement Flow** | Sequence | `13_sequence_order_placement_flow.puml` | `13_sequence_order_placement_flow.svg` |
| 14 | **Component Architecture (CBSE)** | Structural | `14_component_diagram.puml` | `14_component_diagram.svg` |
| 15 | **Deployment Topology** | Physical | `15_deployment_diagram.puml` | `15_deployment_diagram.svg` |
| 16 | **Package Architecture** | Structural | `16_package_diagram.puml` | `16_package_diagram.svg` |
| 17 | **Runtime Object Snapshot** | Runtime | `17_object_diagram.puml` | `17_object_diagram.svg` |

## Compilation

### 1. Recompile PlantUML diagrams to SVG:
```bash
cd /home/aadish/Documents/typst/zawaer
plantuml -tsvg *.puml
```

### 2. Compile Typst Document to PDF:
```bash
cd /home/aadish/Documents/typst/zawaer
typst compile zawaer_diagrams.typ zawaer_diagrams.pdf
```
