<!-- Slide number: 1 -->
# Feature-Driven Development (FDD)
Unit-I

<!-- Slide number: 2 -->
# Feature-Driven Development (FDD):
Feature-Driven Development (FDD) is an iterative, incremental, model-driven Agile software development methodology that organizes the development process around small, client-valued features. Unlike Scrum, where work is planned in sprints, FDD plans, designs, develops, and tracks progress at the feature level.
Feature-Driven Development (FDD) is an Agile methodology that develops software by iteratively designing and implementing small, client-valued features using a domain model and object-oriented design principles.
FDD stands for Feature-Driven Development, a structured, client-centric, and iterative Agile framework.
First developed in 1997 by Jeff De Luca for a massive banking project, it scales exceptionally well for large, complex teams by organizing development around small, client-valued software features that are built in 2 to 10 days

<!-- Slide number: 3 -->
# Feature:
A feature is a small client-valued function expressed in the form:
<action><result><object>
Action – The operation being performed (e.g., Calculate, Generate, Update, Validate).
Result – The outcome of the action.
Object – The business object on which the action is performed.
| Action | Result | Object | Complete Feature |
| --- | --- | --- | --- |
| Calculate | total | invoice | Calculate total invoice |
| Generate | monthly | report | Generate monthly report |

<!-- Slide number: 4 -->
# Principles of FDD:
Domain Object Modeling:

FDD begins with understanding the business domain and creating a domain object model.

The domain model identifies:
Business entities
Relationships
Responsibilities
Business rules

<!-- Slide number: 5 -->
# 2. Develop by Feature:
FDD divides work into features.
A feature is written in the form:
<Action> <Result> <Object>

<!-- Slide number: 6 -->
# 3 Individual Class Ownership
Each class is owned by exactly one developer.

Clear accountability
When implementing a feature requiring changes to multiple classes, the feature team collaborates with the respective class owners.

Customer.java Owner → Alice

<!-- Slide number: 7 -->
# 4 Feature Team
A feature team is formed dynamically for each feature.
Example: Place Online Order

Required classes:
Customer
Product
Cart
Order
Payment

Developers owning these classes form the feature team until the feature is completed.

<!-- Slide number: 8 -->
# 5 Inspections
FDD requires formal inspections of:
Design
Source code

Systematic reviews by peers

<!-- Slide number: 9 -->
# FDD Process:

![Feature Driven Development (FDD) and Agile Modeling](Picture2.jpg)

<!-- Slide number: 10 -->
# Process 1: Develop an Overall Model
Domain experts and developers collaborate to build a high-level domain model, establishing the scope and architecture of the project.
Understand the problem domain and establish the system architecture.
Gather requirements
Conduct domain walkthrough
Identify objects
Discover relationships
Build object model

UML Class Diagrams, Object-Oriented Analysis

<!-- Slide number: 11 -->
# Process 2: Build the Feature List
The team breaks the domain model down into smaller, discrete chunks of functionality (features) that offer tangible value to the client.
The domain model is decomposed into:
Major Feature Sets
Feature Sets
Individual Features

Features:

Register customer
Delete customer
Search customer
Update customer
Feature Set : Customer Management

<!-- Slide number: 12 -->
# Process 3: Plan by Feature
Teams assess, sequence, and assign features based on their complexity, foundational needs, and client priority
Project planning occurs at feature level.
Planning includes:
Feature Prioritization: High Priority, Medium Priority, Low Priority

<!-- Slide number: 13 -->
# Process 4: Design by Feature
The Chief Programmer creates a design package for a specific feature, which is then reviewed and refined by the team before coding begins.
Each feature undergoes detailed design.
Design Inspection: Design correctness ,Reusability ,Complexity, Standards compliance

<!-- Slide number: 14 -->
# Process 5: Build by Feature
Developers write, test, and inspect the code to deliver the feature

Coding
Unit Testing
Code Inspection
Integration
Build Verification Testing

<!-- Slide number: 15 -->
# FDD Roles:
Chief Architect: Designs the overall system and approves the domain model.
Project Manager / Development Manager: Oversees project timelines, budgets, resources, and team activities.
Chief Programmer: The senior developer who leads small feature teams, driving the analysis, design, and building of features.
Class Owners: Developers who are individually responsible for designing, coding, testing, and documenting specific classes within the system.
Domain Experts: Users or representatives who deeply understand client needs and provide critical context for the system