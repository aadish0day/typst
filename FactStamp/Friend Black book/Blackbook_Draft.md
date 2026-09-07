RoomieSync – Smart Flatmate & PG Compatibility Platform
A Project Report
Submitted in partial fulfilment of the
Requirements for the award of the Degree of
BACHELOR OF SCIENCE (INFORMATION TECHNOLOGY)
By
Swara Shripad Shetye
UID / Roll No.: 24BIT056/ 48
Under the esteemed guidance of
Mr. Wilson Rao and Ms. Bertilla Fernandes
DEPARTMENT
OF
INFORMATION TECHNOLOGY
JAI HIND COLLEGE (Empowered Autonomous)
MUMBAI, 400020
MAHARASHTRA
2026-27

JAI HIND COLLEGE
(Empowered Autonomous)
MUMBAI, 400020 MAHARASHTRA
DEPARTMENT OF INFORMATION TECHNOLOGY
CERTIFICATE
This is to certify that the project entitled, RoomieSync – Smart Flatmate & PG Compatibility
Platform, is Bonafide work of Swara Shripad Shetye bearing UID / Roll No.: 24BIT056/ 48
submitted in partial fulfilment of the requirements for the award of degree of BACHELOR
OF SCIENCE in INFORMATION TECHNOLOGY from Jai Hind College Empowered
Autonomous (University of Mumbai).
Internal Guide Coordinator
External Examiner
Date: College Seal

DECLARATION
I hereby declare that the project entitled, RoomieSync – Smart Flatmate & PG Compatibility
Platform done at Jai Hind College (Empowered Autonomous), has not been in any case
duplicated to submit to any other university for the award of any degree. To the best of my
knowledge other than me, no one has submitted to any other university.
The project is done in partial fulfilment of the requirements for the award of degree of
BACHELOR OF SCIENCE (INFORMATIONTECHNOLOGY) to be submitted as Semester
V project as part of our curriculum.
Name and Signature of the Student

ACKNOWLEDGEMENT
I would like to express my sincere gratitude to our Head of Department (Information Technology &
Software Development), Mr. Wilson Rao, for his valuable guidance, encouragement, and continuous
support throughout the development of our project, “RoomieSync – Smart Flatmate & PG Compatibility
Platform.” His suggestions and involvement helped us improve the system and complete the project
successfully.
I would also like to express my heartfelt gratitude to Prof. Ms. Bertilla Fernandes for her constant
encouragement, guidance, and support throughout the project. Her valuable feedback and suggestions
helped us understand the requirements better and develop the project in a structured manner.
I am also thankful to all my friends and seniors who supported me by sharing their ideas, suggestions, and
technical knowledge during the development of the system. Finally, I would like to thank my family for
their constant support, encouragement, and motivation throughout the completion of this project.
Thank you to everyone who contributed directly or indirectly to the successful completion of this project.

Abstract
RoomieSync is a web-based platform desig ned to simplify the process of finding compatible roommates and
suitable accommodation. The system allows users to create profiles by providing personal and lifestyle
preferences such as budget, food preferences, sleep schedule, smoking and drinking habits, occupation, and
interests. Based on these preferences, the system calculates compatibility and displays suitable roommate
matches. Users can send and accept roommate requests, after which they can communicate through the chat
module. The platform also provides property search and booking, meal subscription, digital agreement
generation, shared expense management, and rating and review features. A separate property owner panel
allows owners to add and manage properties along with property images. The system is developed using
modern web technologies and MongoDB for data management, providing an organized and user-friendly
solution for shared accommodation management.

Table of Contents
1. INTRODUCTION
1.1 Background
1.2 Objectives
1.3 Purpose, Scope, and Applicability
1.3.1 Purpose
1.3.2 Scope
1.3.3 Applicability
1.4 Achievements
1.5 Organization of Report
2. SURVEY OF TECHNOLOGIES
3. REQUIREMENT AND ANALYSIS
3.1 Problem Definition
3.2 Requirement Specification
3.3 Planning and Scheduling
3.4 Software and Hardware Requirements
3.5 Preliminary Product Description
3.6 Conceptual Models
4. SYSTEM DESIGN
4.1 Basic Modules
4.2 Data Design
4.2.1 Schema Design
4.2.2 Data Integrity and Constraints
4.3 User Interface Design
4.4 Security Issues
4.5 Test Cases Design
5. IMPLEMENTATION AND TESTING
5.1 Implementation Approach
5.2 Coding Details and Code Efficiency
5.2.1 Code Efficiency
5.3 Testing Approach
5.3.1 Unit Testing
5.3.2 Integration Testing
5.3.3 System Testing
5.4 Modifications and Improvements
6. RESULTS AND DISCUSSION
6.1 User Documentation
7. CONCLUSION
7.1 Conclusion
7.2 Limitations of the System
7.3 Future Scope of the Project
References

Table of Figures
1. Gantt Chart
2. PERT Chart
3. Event Table
4. ER Diagram
5. Class Diagram
6. Object Diagram
7. Use Case Diagram
8. Activity Diagram
9. Sequence Diagram
10. State Diagram
11. Package Diagram
12. Component Diagram
13. Deployment Diagram
14. Data Flow Level 0 Diagram
15. Data Flow Level 0 Diagram
16. Database Schema Design

CHAPTER 1: INTRODUCTION
1.1 Background
Finding a suitable roommate or flatmate has become a major challenge for students and working
professionals relocating to new cities for education or employment. Most people currently rely on social
media groups, messaging applications, or personal references to find roommates. These methods often fail to
consider important compatibility factors such as budget, lifestyle, food preferences, sleeping habits,
cleanliness, smoking habits, and work schedules. As a result, many people experience conflicts,
dissatisfaction, and inconvenience after moving in together.
RoomieSync is a web-based platform developed to simplify the roommate selection process by helping users
find compatible flatmates based on shared preferences and lifestyle. Instead of randomly choosing
roommates, the platform calculates a compatibility score using predefined matching criteria and
recommends the most suitable candidates.
The system also enables users to manage shared living through features such as roommate reviews, shared
expense tracking, digital roommate agreements, and profile verification. By combining these features into a
single platform, RoomieSync aims to make shared accommodation more efficient, transparent, and reliable.

1.2 Objectives
The primary objectives of the RoomieSync project are:
 To provide a platform for students and working professionals to find compatible roommates.
 To calculate a compatibility score based on lifestyle, budget, habits, and personal preferences.
 To simplify the roommate search process and reduce dependence on social media groups and personal
references.
 To improve trust among users through profile verification and roommate reviews.
 To facilitate shared living by providing expense tracking and digital roommate agreements.
 To develop a secure, user-friendly, and responsive web application using modern web technologies.

1.3 Purpose, Scope, and Applicability
1.3.1 Purpose
The purpose of RoomieSync is to provide a centralized platform where users can find suitable roommates
based on compatibility rather than chance. The application aims to reduce roommate conflicts by
considering multiple lifestyle and personal preference factors before suggesting potential matches.
Additionally, the platform helps users manage shared living arrangements through expense management,
agreements, and reviews, creating a safer and more organized living experience.
1.3.2 Scope
The scope of RoomieSync includes the development of a web application that enables users to register,
create profiles, search for compatible roommates, and communicate through the platform.
The system supports multiple user roles such as:
 User (Student/Working Professional)
 Property/Flat Owner
 Administrator
Major functionalities include:
 User Registration and Login
 Profile Management
 Lifestyle-Based Compatibility Matching
 Flat and Room Listings
 Compatibility Score Calculation
 Roommate Request Management
 Shared Expense Tracking
 Digital Roommate Agreement
 Roommate Rating and Review System
 Admin Dashboard for User and Listing Management
The project is designed as a web application and can be accessed from desktops, laptops, tablets, and mobile
devices through modern web browsers.
1.3.3 Applicability
RoomieSync can be applied in various real-world situations where people need shared accommodation.
The system is useful for:
 College students searching for hostel or flatmates.
 Working professionals relocating to new cities.
 Property owners who wish to find compatible tenants.
 Paying Guest (PG) operators who want to recommend suitable roommates.
 Individuals looking for safer and more organized shared living arrangements.
The application can be implemented in educational institutions, metropolitan cities, co-living spaces, rental
housing communities, and student accommodation services. It has the potential to reduce roommate
conflicts, improve user satisfaction, and promote a more efficient shared living ecosystem.

1.4 Achievements
The major achievements of the RoomieSync project are:
 Developed a centralized platform for finding suitable roommates and shared accommodation.
 Implemented user registration, login, authentication, and profile management.
 Developed a compatibility matching system based on user lifestyle preferences.
 Implemented roommate request functionality with accept/reject options.
 Added a chat module that becomes available after a roommate request is accepted.
 Developed property search and booking functionality.
 Created a separate property owner panel for adding and managing properties.
 Implemented property image uploading in JPG format.
 Added meal subscription management for users.
 Implemented digital roommate agreement generation.
 Developed an expense management module for recording and managing shared expenses.
 Added rating and review functionality.
 Implemented light and dark mode for better user experience.
 Used MongoDB for storing and managing application data.

1.5 Organisation of Report
The report is organized into different chapters that describe the development of the RoomieSync system in a
systematic manner.
 Chapter 1 – Introduction
This chapter provides an overview of the RoomieSync – Smart Flatmate & PG Compatibility Platform. It
explains the background and motivation behind developing the system and identifies the problems faced by
students and individuals while searching for compatible roommates and suitable accommodation. The
chapter presents the problem statement, objectives, scope, achievements, and organization of the report. It
gives the reader an understanding of the purpose and overall functionality of the proposed system.
 Chapter 2 – Survey of Technologies
This chapter describes the technologies and development tools used to develop RoomieSync. It covers the
frontend, backend, database, communication technologies, and other supporting tools used in the project.
The chapter explains the role of technologies such as HTML, CSS, JavaScript, React.js, Node.js, Express.js,
MongoDB, and Mongoose in the development of the application. It also explains why these technologies
were selected and how they contribute to the overall functionality of the system.
 Chapter 3 – Requirement and Analysis
This chapter focuses on the analysis of the proposed system and identifies the requirements necessary for its
development. It includes the functional and non-functional requirements, hardware and software
requirements, feasibility study, and analysis of the existing and proposed systems. The chapter also describes
the major modules of RoomieSync, such as user profile management, roommate compatibility and matching,
property management, meal subscription, agreement generation, expense management, chat, and reviews.
 Chapter 4 – System Design
This chapter presents the detailed design of the RoomieSync system. It describes the overall system
architecture and the interaction between different components and modules. The chapter includes Data Flow
Diagrams (DFDs), database design, package diagrams, deployment diagrams, component diagrams, and user
interface wireframes. It also explains the database structure and relationships between the different entities
used in the system. The design provides a blueprint for implementing the proposed application.
 Chapter 5 – Implementation and Testing
This chapter explains how the designed system is implemented using the selected technologies. It covers the
implementation approach, input and output design, database implementation, table/collection structures,
code modules, and complete system implementation. The chapter also describes the testing process used to
verify the correctness and reliability of the application. It includes unit testing, integration testing, and
system testing to ensure that individual modules work correctly and that all modules function together as
expected.
 Chapter 6 – Results and Discussion
This chapter presents the results obtained after implementing the RoomieSync system. It demonstrates the
working of the major modules through screenshots and explains the outputs generated by the system. The
chapter discusses important functionalities such as user profile management, compatibility matching,
roommate requests, chat, property management and booking, meal subscriptions, agreement generation,
expense management, and reviews. It also evaluates whether the Implemented system meets the
requirements and objectives defined earlier in the report.

 Chapter 7 – Conclusion
This chapter summarizes the overall development and achievements of the RoomieSync project. It explains
how the system addresses the problem of finding compatible roommates and managing shared
accommodation. The chapter also discusses the limitations of the current system and identifies possible
improvements and additional functionalities that can be implemented in the future.
References
This chapter contains the references and resources used during the development of the RoomieSync project.
It includes official technology documentation, websites, technical resources, and other relevant materials
referred to for understanding and implementing the technologies and functionalities used in the system.

CHAPTER 2: SURVEY OF TECHNOLOGIES
2.1 Introduction
The development of a modern web application requires selecting appropriate technologies that provide
security, scalability, performance, and ease of development. RoomieSync is designed as a full-stack web
application using modern web development technologies. The selected technologies support responsive user
interfaces, secure user authentication, efficient database management, and reliable server-side processing.
2.2 Front-End Technologies
2.2.1 HTML5
HTML5 (Hyper Text Markup Language) is the standard markup language used for designing the structure of
web pages. It provides semantic elements that improve readability, accessibility, and browser compatibility.
HTML5 forms the foundation of the RoomieSync user interface.
Features:
 Semantic elements
 Multimedia support
 Cross-browser compatibility
 Improved accessibility
2.2.2 CSS3
CSS3 (Cascading Style Sheets) is used to style the web pages and enhance the overall appearance of the
application. It enables responsive layouts, animations, and attractive user interfaces.
Features:
 Responsive design
 Flexbox and Grid layouts
 Animations and transitions
 Better user experience
2.2.3 JavaScript
JavaScript is the primary scripting language used to add interactivity and dynamic functionality to the
website. It enables form validation, event handling, and communication between the client and server.
Features:
 Dynamic content
 Event handling
 Form validation
 API integration
2.2.4 React.js
React.js is an open-source JavaScript library used for building modern, component-based user interfaces. It
allows reusable components and improves application performance through the Virtual DOM.
Advantages:
 Component-based architecture
 Virtual DOM
 High performance
 Reusable code
 Easy maintenance

2.2.5 Tailwind CSS
Tailwind CSS is a utility-first CSS framework used for designing responsive and modern user interfaces
without writing extensive custom CSS.
Advantages:
 Faster UI development
 Responsive utilities
 Reusable utility classes
 Customizable design
2.3 Back-End Technologies
2.3.1 Node.js
Node.js is a JavaScript runtime environment that executes JavaScript on the server side. It enables fast and
scalable backend development.
Advantages:
 High performance
 Event-driven architecture
 Non-blocking I/O
 Scalable applications
2.3.2 Express.js
Express.js is a lightweight web application framework built on Node.js. It simplifies API development,
routing, middleware management, and request handling.
Advantages:
 Fast routing
 Middleware support
 REST API development
 Easy integration with MongoDB
2.3.3 MongoDB
MongoDB is a NoSQL database that stores data in JSON-like documents. It provides flexibility and
scalability for handling user profiles, property listings, compatibility data, and requests.
Advantages:
 Flexible schema
 High scalability
 Fast querying
 JSON document storage
2.3.4 JWT (JSON Web Token)
JWT is used to provide secure authentication and authorization. After successful login, the server generates a
token that verifies the identity of the user for future requests.
Advantages:
 Secure authentication
 Stateless sessions
 Role-based access

 Easy implementation
2.4 Development Tools
Visual Studio Code (VS Code) Visual Studio Code is used as the primary code editor due to its lightweight
design and rich extension support.
Git GitHub
Git is used for version control, while GitHub is used to store the project repository and manage code
changes.
Postman
Postman is used to test backend APIs during development.

CHAPTER 3: REQUIREMENTS AND ANALYSIS
3.1 Problem Definition
Finding a suitable flatmate or roommate is a common challenge for students and working professionals
relocating to new cities. Most people rely on social media, personal references, or online listings, which do
not consider important factors such as budget, lifestyle, food preferences, work schedules, and personal
habits. This often leads to compatibility issues and conflicts after moving in together.
RoomieSync addresses this problem by providing a platform that matches users based on compatibility
scores and shared preferences. It also includes features such as property listings, roommate requests, shared
expense tracking, and digital roommate agreements to make shared living more organized and convenient.

3.2 Requirements Specification
The requirements of RoomieSync are divided into Functional Requirements and
Non-Functional Requirements.
3.2.1 Functional Requirements
The system shall provide the following functionalities:
User Module
 User Registration
 User Login
 Profile Management
 Search for Flatmates
 Search for Properties
 View Compatibility Score
 Send Roommate Requests
 Accept or Reject Requests
 Track Shared Expenses
 Rate and Review Roommates
Property Owner Module
 Register/Login
 Add Property Listings
 Update Property Details
 Delete Property Listings
 View Booking Requests
 Approve or Reject Booking Requests
Admin Module
 Manage Users
 Verify User Profiles
 Manage Property Listings
 Remove Invalid Listings
 Monitor Reviews
 Generate Reports
3.2.2 Non-Functional Requirements
The system should satisfy the following quality requirements:
Performance
 Fast response time
 Efficient compatibility calculation
 Quick database retrieval
Security
 Secure authentication using JWT
 Password encryption
 Role-based authorization
Reliability
 Continuous availability

 Accurate compatibility calculation
 Reliable database storage
Usability
 Easy navigation
 Responsive design
 User-friendly interface
Scalability
The system should support an increasing number of users and property listings without affecting
performance.
3.3 Planning and Scheduling
Figure. 3.6.2 Pert Chart

3.4 Software and Hardware Requirements
3.4.1 Software Requirements
Software Purpose
Windows 10/11 or Linux Operating System
Visual Studio Code Code Editor
React.js Front-End Development
HTML5 Web Page Structure
CSS3 Styling
JavaScript Client-side Programming
Node.js Server-side Runtime
Express.js Backend Framework
MongoDB Database
JWT User Authentication
Postman API Testing
Git & GitHub Version Control
3.4.2 Hardware Requirements
Hardware Minimum Requirement
Processor Intel Core i3 (8th Gen) / AMD Ryzen 3 or higher
RAM 8 GB (Minimum 4 GB)
Storage 256 GB SSD (Minimum 50 GB free space)
Display 1366 × 768 Resolution
Internet Broadband Connection
Keyboard & Mouse Standard Input Devices

3.5 Preliminary Product Description
Modules
1. Authentication Module
This functional unit allows the users to register, login, change password. It also secures user access to the
system and confirms user identities. In order to use other features of the system, users have to authenticate.
2. User Profile & Lifestyle Module
The user profile lifestyle module enables the user to set up and modify their user profile which consists of
data such as budget, dietary preference, occupational activities, sleep schedule, hygiene level, smoke
preference, and hobbies. This gathered data will be instrumental in locating a fellow tenant.
3. Compatibility Matching Module
The compatibility matching algorithm will evaluate potential roommates by comparing their lifestyles and
compute a compatibility score. It will also suggest a roommate whom you might find most compatible so
that co-living becomes a breeze and pleasant one.
4. Property Management Module
Property Listing Managers can utilize this module to create new entries, delete, or update existing PG/Flat
listings. They will also have the privilege of viewing their available properties via the platform with features
such as location filters, budgets, and facilities. When interested, users will be able to click send a booking
inquiry button to initiate contact.
5. Meal Subscription Module
Using this module, the user will have a chance to locate home chefs or mess services in their vicinity, see
weekly meal plans published, subscribe to plans they find suitable, and also manage meal subscriptions.
6. Digital Roommate Agreement Module
After selecting the roommate, digital agreement can be generated. Details like house rules, sharing of
electricity and gas, rent, and other responsibilities can be included. Both the roommates shall have an
opportunity to read, review, and sign the document.
7. Shared Expense Tracker Module
This feature assists roommates in documenting and handling shared expenses such as house rent, utilities,
groceries maintenance, etc. The module calculates automatically every roommate’s share of the expense.
8. Roommate Review & Rating Module
Reviewing and rating other roommates is a post-stay thing that you can do easily. This not only helps in
gaining your community’s trust but also in developing better roommate suggestions for the future.
9. Admin Module
Admin Module: This section gives the administrator the ability to add, remove or edit users, confirm
property listings, perform surveillance on the platform, deal with reports and ensure that the whole system is
up to date and running well.

3.6 Conceptual Models
3.6.1 Gantt Chart
Figure. 3.6.1 Gantt Chart

3.6.3 Event Table
Event
|     | Source  | Action / Process  | Output  | Destination  |
| --- | ------- | ----------------- | ------- | ------------ |
Trigger
|                 |       | System validates registration   | User account created  |              |
| --------------- | ----- | ------------------------------- | --------------------- | ------------ |
| User registers  |       |                                 |                       | Database /   |
|                 | User  | details and creates a new user  | and registration      |              |
| an account      |       |                                 |                       | Frontend UI  |
|                 |       | account.                        | confirmation          |              |
System verifies email/username
|               |       |                                 | Login success and      | Profile Page /  |
| ------------- | ----- | ------------------------------- | ---------------------- | --------------- |
| User logs in  | User  | and password and authenticates  |                        |                 |
|               |       |                                 | authentication status  | Frontend UI     |
the user.
System stores personal details,
User updates  lifestyle preferences, budget, food  Database /
|          | User  |                              | Updated user profile  |             |
| -------- | ----- | ---------------------------- | --------------------- | ----------- |
| profile  |       | preference, sleep schedule,  |                       | Profile UI  |
occupation and interests.
|     |     | Compatibility Engine compares  | Compatibility score  |     |
| --- | --- | ------------------------------ | -------------------- | --- |
User searches
User  the user's preferences with other  and matching  Frontend UI
for roommates
|     |     | user profiles.  | roommate profiles  |     |
| --- | --- | --------------- | ------------------ | --- |
User sends
System records the request and  Roommate request  Database / User
| roommate  | User  |                                 |               |     |
| --------- | ----- | ------------------------------- | ------------- | --- |
|           |       | sends it to the selected user.  | notification  | UI  |
request
| User accepts  |     | System updates the request status  |     |     |
| ------------- | --- | ---------------------------------- | --- | --- |
Database / Chat
roommate  User  and establishes the roommate  Request accepted
Module
| request   |     | connection.          |     |     |
| --------- | --- | -------------------- | --- | --- |
| Roommate  |     | Chat module enables  |     |     |
Chat UI /
request is  System  communication between the  Chat conversation
Database
| accepted  |           | matched users.                   |                   |             |
| --------- | --------- | -------------------------------- | ----------------- | ----------- |
| Property  |           | System stores property details,  |                   | Database /  |
|           | Property  |                                  | Property listing  |             |
owner adds  rent, location, capacity, facilities  Property Owner
|           | Owner  |                           | created  |        |
| --------- | ------ | ------------------------- | -------- | ------ |
| property  |        | and uploaded JPG images.  |          | Panel  |
System retrieves available
| User searches   |       |                               | List of available  |              |
| --------------- | ----- | ----------------------------- | ------------------ | ------------ |
|                 | User  | properties based on selected  |                    | Property UI  |
| for properties  |       |                               | properties         |              |
requirements.
| User requests  |     | System records the booking  |     | Database /  |
| -------------- | --- | --------------------------- | --- | ----------- |
property  User  request and sends it to the  Booking request  Property Owner
| booking        |           | property owner.             |               | Panel            |
| -------------- | --------- | --------------------------- | ------------- | ---------------- |
| Property       |           | System updates the booking  |               |                  |
|                | Property  |                             | Booking       | Database / User  |
| owner accepts  |           | status and confirms the     |               |                  |
|                | Owner     |                             | confirmation  | UI               |
| booking        |           | reservation.                |               |                  |

Event
|     | Source  | Action / Process  | Output  | Destination  |
| --- | ------- | ----------------- | ------- | ------------ |
Trigger

| User           |       | System records the selected meal  |                    |             |
| -------------- | ----- | --------------------------------- | ------------------ | ----------- |
|                |       |                                   | Meal subscription  | Database /  |
| subscribes to  | User  | plan, duration and subscription   |                    |             |
|                |       |                                   | confirmation       | Meals UI    |
| meal plan      |       | details.                          |                    |             |
System uses user, roommate and
| User generates  |       |                                   | Generated  | Agreement UI /  |
| --------------- | ----- | --------------------------------- | ---------- | --------------- |
|                 | User  | property details to generate the  |            |                 |
| agreement       |       |                                   | agreement  | Database        |
agreement.
System records expense amount,
| User adds an  |       |                                   | Expense record and  | Database /  |
| ------------- | ----- | --------------------------------- | ------------------- | ----------- |
|               | User  | category, date and participating  |                     |             |
| expense       |       |                                   | updated balance     | Expense UI  |
roommates.
System calculates and displays
User views
User  the user's share and outstanding  Expense summary  Frontend UI
expense details
amount.
System stores the rating and
| User submits a  |       |                                   |                    | Database /  |
| --------------- | ----- | --------------------------------- | ------------------ | ----------- |
|                 | User  | review for the relevant roommate  | Review and rating  |             |
| review          |       |                                   |                    | Review UI   |
or property.

Figure 3.6.3 Event Table

|     |     |     |     |     |
| --- | --- | --- | --- | --- |

3.6.4 ER Diagram
Figure 3.6.4 ER Diagram

3.6.5 Class Diagram
Figure 3.6.5 Class Diagram

3.6.6 Object Diagram
3.6.6 Object Diagram

3.6.7 Use Case Diagram
3.6.7 Use Case Diagram

3.6.8 Activity Diagram
3.6.8 Activity Diagram

3.6.9 Sequence Diagram
3.6.9 Sequence Diagram

3.6.10 State Diagram
3.6.10 State Diagram

3.6.11 Package Diagram
3.6.11 Package Diagram

3.6.12 Component Diagram
3.6.12 Component Diagram

3.6.13 Deployment Diagram
3.6.13 Deployment Diagram

3.6.14 Data Flow Level
Data Flow Context Level
Data Flow Level 1
Data Flow Level 2 User Authentication

Data Flow Level 2 Roommate Matching
Data Flow Level 2 Property Booking
Data Flow diagram (Level 2) Meal Subscription
Data Flow Level 2 Agreement Generation

Data Flow Level 2 Expense Management
3.6.14 Data Flow Level

3.6.15 Database Schema Design
3.6.16 Database Schema Design

CHAPTER 4: SYSTEM DESIGN
4.1 Basic Modules
1. Authentication Module
This functional unit allows the users to register, login, change password. It also secures user access to the
system and confirms user identities. In order to use other features of the system, users have to authenticate.
2. User Profile & Lifestyle Module
The user profile lifestyle module enables the user to set up and modify their user profile which consists of
data such as budget, dietary preference, occupational activities, sleep schedule, hygiene level, smoke
preference, and hobbies. This gathered data will be instrumental in locating a fellow tenant.
3. Compatibility Matching Module
The compatibility matching algorithm will evaluate potential roommates by comparing their lifestyles and
compute a compatibility score. It will also suggest a roommate whom you might find most compatible so
that co-living becomes a breeze and pleasant one.
4. Property Management Module
Property Listing Managers can utilize this module to create new entries, delete, or update existing PG/Flat
listings. They will also have the privilege of viewing their available properties via the platform with features
such as location filters, budgets, and facilities. When interested, users will be able to click send a booking
inquiry button to initiate contact.
5. Meal Subscription Module
Using this module, the user will have a chance to locate home chefs or mess services in their vicinity, see
weekly meal plans published, subscribe to plans they find suitable, and also manage meal subscriptions.
6. Digital Roommate Agreement Module
After selecting the roommate, digital agreement can be generated. Details like house rules, sharing of
electricity and gas, rent, and other responsibilities can be included. Both the roommates shall have an
opportunity to read, review, and sign the document.
7. Shared Expense Tracker Module
This feature assists roommates in documenting and handling shared expenses such as house rent, utilities,
groceries maintenance, etc. The module calculates automatically every roommate’s share of the expense.
8. Roommate Review & Rating Module
Reviewing and rating other roommates is a post-stay thing that you can do easily. This not only helps in
gaining your community’s trust but also in developing better roommate suggestions for the future.
9. Admin Module
Admin Module: This section gives the administrator the ability to add, remove or edit users, confirm
property listings, perform surveillance on the platform, deal with reports and ensure that the whole system is
up to date and running well.

4.2 Data Design
4.2.1 Schema Design

User Table
| Attribute                 | Type                     | Description              | PK   |
| ------------------------- | ------------------------ | ------------------------ | ---- |
| userId                    | String                   | Unique User ID           | Yes  |
| fullName                  | String                   | User Name                | No   |
| email                     | String                   | Email Address            | No   |
| password                  | String                   | Encrypted Password No    |      |
| phone                     | String                   | Mobile Number            | No   |
| occupation                | String                   | Student/Professional No  |      |
| budget                    | Number Preferred Budget  |                          | No   |
| foodPreference            | String                   | Veg/Non-Veg              | No   |
| sleepSchedule             | String                   | Sleep Timing             | No   |
| cleanliness               | String                   | Cleanliness Level        | No   |
| hobbies                   | String                   | User Hobbies             | No   |
| preferredLocation String  |                          | Preferred Area           | No   |
Property Table
| Attribute            | Type                              | Description          | PK   |
| -------------------- | --------------------------------- | -------------------- | ---- |
| propertyId           | String                            | Unique Property ID   | Yes  |
| ownerId              | String                            | Property Owner ID    | No   |
| propertyName String  |                                   | Property Name        | No   |
| location             | String                            | Property Location    | No   |
| rent                 | Number Monthly Rent               |                      | No   |
| amenities            | String                            | Property Facilities  | No   |
| availability         | Boolean Property Availability No  |                      |      |
Compatibility Table
| Attribute   | Type    | Description      | PK   |
| ----------- | ------- | ---------------- | ---- |
| matchId     | String  | Match ID         | Yes  |
| userId      | String  | User ID          | No   |
| roommateId  | String  | Matched User ID  | No   |
compatibilityScore Number Compatibility Score No

| Attribute  |     | Type    | Description    | PK  |
| ---------- | --- | ------- | -------------- | --- |
| status     |     | String  | Match Status   | No  |
Meal Subscription Table
| Attribute            |     | Type  Description             |     | PK   |
| -------------------- | --- | ----------------------------- | --- | ---- |
| mealId               |     | String  Meal Subscription ID  |     | Yes  |
| userId               |     | String  User ID               |     | No   |
| providerName String  |     | Home Chef/Mess Name No        |     |      |
| mealPlan             |     | String  Weekly/Monthly Plan   |     | No   |
| amount               |     | Number Subscription Fee       |     | No   |
| status               |     | String  Active/Cancelled      |     | No   |
Agreement Table
| Attribute           | Type               | Description          | PK   |     |
| ------------------- | ------------------ | -------------------- | ---- | --- |
| agreementId String  |                    | Agreement ID         | Yes  |     |
| userId              | String             | User ID              | No   |     |
| roommateId String   |                    | Roommate ID          | No   |     |
| rentShare           | Number Rent Share  |                      | No   |     |
| rules               | String             | House Rules          | No   |     |
| status              | String             | Agreement Status No  |      |     |
Expense Table
| Attribute Type    |                        | Description          | PK   |     |
| ----------------- | ---------------------- | -------------------- | ---- | --- |
| expenseId String  |                        | Expense ID           | Yes  |     |
| userId            | String                 | User ID              | No   |     |
| category          | String                 | Expense Category No  |      |     |
| amount            | Number Expense Amount  |                      | No   |     |
| date              | Date                   | Expense Date         | No   |     |
Review Table
| Attribute Type  |                         | Description PK  |      |     |
| --------------- | ----------------------- | --------------- | ---- | --- |
| reviewId        | String                  | Review ID       | Yes  |     |
| userId          | String                  | User ID         | No   |     |
| rating          | Number Rating (1–5) No  |                 |      |     |
| review          | String                  | Feedback        | No   |     |

Admin Table
Attribute Type Description PK
adminId String Unique Admin ID Yes
name String Admin Name No
email String Admin Email No
password String Encrypted Password No
4.2.2 Data Integrity and Constraints
Keeping information consistent is a core requirement for the RoomieSync database, and the system enforces
a set of rules designed to catch invalid or duplicate data before it ever gets stored. Accountcreation requires a
valid email address. Passwords run through bcrypt.js before storage, so plaintext credentials never sit in the
database. Fields like name, email, password, and budget can’t be leftblank. Property owners can only
manage their own listings, and users can only modify their own profiles and expense records. Together these
rules cover what gets entered, how records relate to each other, and who’s allowed to do what — which
keeps the data trustworthy and the system predictable.
Data Integrity Constraints
Every user account must have an associated email address. Passwords are hashed with bcrypt.js before
storage. All required fields must be completed before a record is saved. Access to features is restricted to
authenticated users. Property owners can only delete listings they themselves created. A roommate request
can only be rejected once. Rental agreements aren’t generated until both parties have agreed. Shared
expenses must be linked to valid user accounts. Ratings can only be submitted after the two users have had a
real interaction.

4.3 User interface design (Wireframes)
1. Authentication Module
Login · Register · Forgot Password

2. User Profile & Lifestyle Module
Complete Profile

3. Compatibility Matching Module
Search Roommates

4. Roommate Request Module
Pending · Accepted · Reject · Chat

5. Property Management Module
Search · Cards · Filters · Details · Book

6. Meal Subscription Module
Providers · Weekly/Monthly Menu · Subscribe

7. Digital Agreement Module
Roommate Details · Rent Share · House Rules · Generate/Download

8. Shared Expense Module
Expense List · Add Expense · Split · Balance

9. Review & Rating Module
Give Rating · Write Review · Submit

10. Admin Module
Dashboard · Manage Users · Manage Properties · Reports · Meal Providers · Logout

4.4 Security Issues
Because RoomieSync handles sensitive pe rsonal and financial information, security is built into the
application at multiple levels rather than treated as an afterthought. Passwords are hashed with bcrypt.js so
stored credentials are never readable. JSON Web Tokens handle authentication, and protected routes keep
unauthenticated users away from restricted pages. All user inputs are validated before processing, which cuts
down exposure to malicious data. Sensitive operations — managing properties, generating agreements,
tracking shared expenses — sit behind proper authorization checks. Taken together, these measures protect
user data both in transit and at rest, while keeping the boundary between client and server clearly enforced.
Security Measures Implemented
1. Password Encryption: Passwords are hashed with bcrypt.js before being written to the database, so
plaintext credentials are never stored.
2. JWT Authentication: JSON Web Tokens are issued at login and verified before any protected request
goes through.
3. Role-Based Access: Permissions differ between standard users and administrators, so each role is limited
to actions appropriate to it.
4. Input Validation: User-supplied data is checked before processing to reduce the risk of harmful or
malformed input reaching the system.
5. Protected Routes: Certain pages and endpoints are only reachable by users who are currently logged in.
6. Secure Database Access: The database is only reached through backend API calls, keeping it off-limits to
direct external queries.
7. Session Management: JSON Web Tokens are validated on every request before any action is taken.
8. Data Privacy: Access to records is limited to users who have been authorized to view them.

4.5 Test Cases Design
Test Condition  Input Sele cted  Expected Result  Actual Result
|             |     |                            |     |     | Login attempt with  |     | Login attempt with  |
| ----------- | --- | -------------------------- | --- | --- | ------------------- | --- | ------------------- |
| User Login  |     | Email = "", Password = ""  |     |     |                     |     |                     |
|             |     |                            |     |     | empty credentials   |     | empty credentials   |
Email = "swara@gmail.com",
|     |     |     |     |     | Login successful  |     | Login successful  |
| --- | --- | --- | --- | --- | ----------------- | --- | ----------------- |
Password = "12345678"
Name = "", Email = "", Password =  Registration attempt  Registration attempt
User Registration
|                 |     |                             | ""  |                       | with empty fields   |                       | with empty fields   |
| --------------- | --- | --------------------------- | --- | --------------------- | ------------------- | --------------------- | ------------------- |
|                 |     |                             |     |                       | User registered     |                       | User registered     |
|                 |     | Valid registration details  |     |                       |                     |                       |                     |
|                 |     |                             |     |                       | successfully        |                       | successfully        |
|                 |     |                             |     |                       | Validation message  |                       | Validation message  |
| Update Profile  |     | Profile fields left empty   |     |                       |                     |                       |                     |
|                 |     |                             |     |                       | displayed           |                       | displayed           |
|                 |     |                             |     |                       | Profile updated     |                       | Profile updated     |
|                 |     | Valid profile details       |     |                       |                     |                       |                     |
|                 |     |                             |     |                       | successfully        |                       | successfully        |
| Compatibility   |     |                             |     | Compatible roommates  |                     | Compatible roommates  |                     |
User preferences entered
| Matching  |     |     |     |     | displayed  |     | displayed  |
| --------- | --- | --- | --- | --- | ---------- | --- | ---------- |
Location = Mumbai, Budget =  Matching properties  Matching properties
Property Search
|                   |     |                          | ₹10,000  |     | displayed           |     | displayed           |
| ----------------- | --- | ------------------------ | -------- | --- | ------------------- | --- | ------------------- |
|                   |     |                          |          |     | Booking confirmed   |     | Booking confirmed   |
| Property Booking  |     | Selected valid property  |          |     |                     |     |                     |
|                   |     |                          |          |     | successfully        |     | successfully        |
|                   |     |                          |          |     | Validation message  |     | Validation message  |
No meal plan selected
Meal Subscription
|                    |     |                             |     |                       | displayed           |                       | displayed           |
| ------------------ | --- | --------------------------- | --- | --------------------- | ------------------- | --------------------- | ------------------- |
|                    |     |                             |     |                       | Meal subscription   |                       | Meal subscription   |
|                    |     | Weekly meal plan selected   |     |                       |                     |                       |                     |
|                    |     |                             |     |                       | successful          |                       | successful          |
|                    |     |                             |     | Agreement generation  |                     | Agreement generation  |                     |
| Digital Agreement  |     | Required fields left blank  |     |                       |                     |                       |                     |
|                    |     |                             |     |                       | failed              |                       | failed              |
|                    |     |                             |     | Agreement generated   |                     | Agreement generated   |                     |
|                    |     | Valid agreement details     |     |                       |                     |                       |                     |
|                    |     |                             |     |                       | successfully        |                       | successfully        |
| Shared Expense     |     |                             |     |                       | Validation message  |                       | Validation message  |
Amount field left blank
| Tracker  |     |                            |     |     | displayed      |     | displayed      |
| -------- | --- | -------------------------- | --- | --- | -------------- | --- | -------------- |
|          |     | Amount = ₹500, Category =  |     |     | Expense added  |     | Expense added  |

|     |     |     | Grocery  |     | successfully  |     | successfully  |
| --- | --- | --- | -------- | --- | ------------- | --- | ------------- |

Test Condition Input Selected Expected Result Actual Result
Review submitted Review submitted
Review & Rating Rating = 5, Review entered
successfully successfully
User logged out User logged out
Logout User clicks Logout
successfully successfully

CHAPTER 5: IMPLEMENTATION AND TESTING
5.1 Implementation Approaches
Project Summary
RoomieSync is a smart flatmate and accommodation management system designed to help users find
suitable roommates, search and book properties, communicate with matched users, subscribe to meal plans,
generate agreements, and manage shared expenses. The system is implemented using a modular approach,
where each major functionality is developed as a separate module. MongoDB is used for storing user,
property, roommate matching, chat, meal, agreement, expense, and review data. The implementation focuses
on providing a simple, secure, efficient, and user-friendly application.

5.2 Coding Details and Code Efficiency
The RoomieSync application is developed using a modular coding approach. The code is divided into
separate components for authentication, user profile management, roommate matching, property
management, chat, meal subscription, agreement generation, expense management, and reviews. Reusable
functions and components are used wherever possible to reduce code duplication. Proper validation and
error handling are implemented to improve the reliability of the system. Database queries are designed to
retrieve only the required information, thereby reducing unnecessary processing and improving application
performance.
5.2.1 Coding details:
Module 1 – Roommate Compatibility Matching
Frontend
import React, { useState, useEffect, useRef } from 'react';
import {
Sparkles, Filter, CheckCircle, XCircle, Send, Eye, ShieldCheck,
Heart, UserCheck, Flame, Search, MapPin, DollarSign, Utensils, Moon, Briefcase, Smile, CheckCircle2, Clock, Star, X, Check
} from 'lucide-react';
import { apiService } from '../services/api';
import { calculateCompatibility } from '../services/matchingEngine';
const DATA_AVATAR_FALLBACK = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='100' height='100'
viewBox='0 0 24 24' fill='%231f2937' stroke='%239ca3af' stroke-width='1.5'><rect width='100%' height='100%' fill='%23374151'/><circle
cx='12' cy='8' r='4'/><path d='M6 21v-2a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v2'/></svg>";
export default function MatchingPage({ currentUser }) {
const [userProfile, setUserProfile] = useState({});
const [candidates, setCandidates] = useState([]);
const [searchQuery, setSearchQuery] = useState('');
const [budgetFilter, setBudgetFilter] = useState('All');
const [foodFilter, setFoodFilter] = useState('All');
const [selectedCandidate, setSelectedCandidate] = useState(null);
const [requestedIds, setRequestedIds] = useState([]);
const [matchRequests, setMatchRequests] = useState([]);
const [loading, setLoading] = useState(true);
const isMounted = useRef(true);
useEffect(() => {
isMounted.current = true;
const fetchData = async () => {
const userId = currentUser?.id || currentUser?._id;
if (!userId) {
if (isMounted.current) setLoading(false);
return;
}
try {
if (isMounted.current) setLoading(true);
const safeGetProfile = (id) => apiService.getProfile(id).catch(() => ({}));
const safeGetUsers = () => apiService.getUsers().catch(() => []);
const [myProfile, users] = await Promise.all([
safeGetProfile(userId),
safeGetUsers()
]);
if (!isMounted.current) return;
setUserProfile(myProfile || {});
const otherUsers = (users || []).filter(u => u && (u.id || u._id) !== userId && u.role === 'user');
const candidatePromises = (otherUsers || []).map(async (u) => {
const uId = u?.id || u?._id;
const prof = uId ? await safeGetProfile(uId) : {};
const score = calculateCompatibility(myProfile || {}, prof || {});
return { user: u || {}, profile: prof || {}, score: score || 50 };
});
const candidateList = await Promise.all(candidatePromises);
if (!isMounted.current) return;
candidateList.sort((a, b) => (b.score || 0) - (a.score || 0));
setCandidates(candidateList);
setMatchRequests([]);
} catch (err) {

console.error('Failed to fetch matching data:', err);
} finally {
if (isMounted.current) {
setLoading(false);
}
}
};
fetchData();
return () => {
isMounted.current = false;
};
}, [currentUser?.id, currentUser?._id]);
const handleImageError = (e) => {
e.target.onerror = null;
e.target.src = DATA_AVATAR_FALLBACK;
};
const filteredCandidates = (candidates || []).filter(item => {
if (!item) return false;
if (searchQuery && searchQuery.trim()) {
const q = searchQuery.toLowerCase();
const nameMatch = (item.user?.name || '').toLowerCase().includes(q);
const locMatch = (item.profile?.preferredLocation || '').toLowerCase().includes(q);
const occMatch = (item.profile?.occupation || '').toLowerCase().includes(q);
if (!nameMatch && !locMatch && !occMatch) return false;
}
if (foodFilter !== 'All' && item.profile?.foodPref !== foodFilter) return false;
if (budgetFilter !== 'All') {
const maxB = Array.isArray(item.profile?.budget) && item.profile.budget.length === 2
? Number(item.profile.budget[1])
: 25000;
if (budgetFilter === 'Under15k' && maxB > 15000) return false;
if (budgetFilter === '15k-25k' && (maxB < 15000 || maxB > 25000)) return false;
}
return true;
});
const handleSendMatch = (candidateId) => {
if (!candidateId) return;
setRequestedIds(prev => (prev || []).includes(candidateId) ? prev : [...(prev || []), candidateId]);
};
const handleRespond = (reqId, status) => {
if (!reqId) return;
setMatchRequests(prev => (prev || []).map(r => r?.id === reqId ? { ...r, status } : r));
};
if (loading) {
return (
<div className="max-w-7xl mx-auto py-12 px-4 flex flex-col items-center justify-center min-h-[400px]">
<Sparkles className="w-8 h-8 text-[var(--accent-gold)] animate-spin mb-3" />
<p className="text-sm theme-text-sub font-medium">Finding potential roommate matches...</p>
</div>
);
}
return (
<div className="max-w-7xl mx-auto py-6 px-4 space-y-8">
{/* Page Header */}
<div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-4">
<div>
<div className="flex items-center gap-2 mb-1">
<span className="text-xs font-semibold theme-text-accent uppercase tracking-widest">Matching Engine</span>
<span className="theme-badge-amber text-[10px] font-bold px-2 py-0.5 rounded-full flex items-center gap-1 font-mono-numbers">
<Flame className="w-3 h-3 text-[var(--accent-gold)]" /> AI Weighted 6-Factor
</span>
</div>
<h1 className="text-3xl font-extrabold theme-text-main font-display tracking-tight">
Find Your Ideal Roommate
</h1>
<p className="theme-text-sub text-xs mt-1">
Algorithmically scored based on budget overlap, food diet, sleep rhythm, and cleanliness habits.
</p>
</div>
{/* Search & Filter Controls Bar */}
<div className="flex flex-col sm:flex-row items-center gap-3 w-full lg:w-auto">
{/* Search Box */}

<div className="relative w-full sm:w-64">
<Search className="w-4 h-4 theme-text-muted absolute left-3.5 top-3" />
<input
type="text"
placeholder="Search by name, role or city..."
value={searchQuery}
onChange={(e) => setSearchQuery(e.target.value)}
className="w-full theme-input py-2 pl-10 pr-4 text-xs outline-none"
/>
</div>
{/* Filters Dropdown */}
<div className="flex items-center gap-2 w-full sm:w-auto">
<select
value={foodFilter}
onChange={(e) => setFoodFilter(e.target.value)}
className="theme-input px-3 py-2 text-xs outline-none font-medium flex-1 sm:flex-initial"
>
<option value="All">All Diets</option>
<option value="Veg">Vegetarian</option>
<option value="Non-Veg">Non-Veg</option>
<option value="Vegan">Vegan</option>
</select>
<select
value={budgetFilter}
onChange={(e) => setBudgetFilter(e.target.value)}
className="theme-input px-3 py-2 text-xs outline-none font-medium flex-1 sm:flex-initial font-mono-numbers"
>
<option value="All">All Budgets</option>
<option value="Under15k">Under ₹15,000</option>
<option value="15k-25k">₹15k - ₹25k</option>
</select>
</div>
</div>
</div>
{/* Incoming Match Requests Banner */}
{(matchRequests || []).length > 0 && (
<div className="bento-card p-6 border-[var(--surface-border-accent)]">
<div className="flex items-center justify-between mb-4">
<h2 className="text-sm font-bold theme-text-accent uppercase tracking-wider flex items-center gap-2 font-display">
<Sparkles className="w-4 h-4 text-[var(--accent-gold)]" /> Pending Roommate Match Requests Received
</h2>
<span className="text-xs theme-badge-emerald px-2.5 py-0.5 rounded-full font-mono-numbers">
{(matchRequests || []).filter(r => r?.status === 'pending').length} Action Required
</span>
</div>
<div className="grid grid-cols-1 md:grid-cols-2 gap-4">
{(matchRequests || []).map(req => (
<div key={req?.id || req?.fromUser?.name} className="p-4 rounded-2xl bento-card-static flex items-center justify-between gap-4">
<div className="flex items-center gap-3">
<img
src={req?.fromUser?.avatar || DATA_AVATAR_FALLBACK}
alt=""
onError={handleImageError}
className="w-12 h-12 rounded-xl object-cover ring-2 ring-[var(--brand-accent)]/40"
/>
<div>
<h4 className="text-sm font-bold theme-text-main font-display">{req?.fromUser?.name || 'User'}</h4>
<p className="text-xs text-[var(--accent-emerald)] font-bold font-mono-numbers">{req?.score || 50}% High Match Score</p>
</div>
</div>
{req?.status === 'pending' ? (
<div className="flex items-center gap-2">
<button
onClick={() => handleRespond(req.id, 'accepted')}
className="px-3.5 py-2 rounded-xl gradient-btn text-xs font-bold flex items-center gap-1 transition-all duration-200 hover:-
translate-y-0.5 active:scale-95"
>
<CheckCircle className="w-3.5 h-3.5" /> Accept
</button>
<button
onClick={() => handleRespond(req.id, 'rejected')}

className="px-3 py-2 rounded-xl theme-btn-secondary text-xs font-semibold transition-all duration-200 hover:-translate-y-0.5
active:scale-95"
>
Decline
</button>
</div>
) : (
<span className={`text-xs font-bold px-3 py-1 rounded-full flex items-center gap-1.5 ${req?.status === 'accepted' ? 'theme-badge-
emerald' : 'theme-badge-amber'}`}>
{req?.status === 'accepted' ? (
<>
<Sparkles className="w-3.5 h-3.5" />
<span>Match Accepted</span>
</>
) : (
<span>Request Declined</span>
)}
</span>
)}
</div>
))}
</div>
</div>
)}
{/* Recommended Candidates Grid */}
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
{(filteredCandidates || []).length === 0 ? (
<div className="col-span-full bento-card p-12 text-center text-xs theme-text-muted">
No candidate roommate profiles match your selected filters. Try broadening your criteria.
</div>
) : (
(filteredCandidates || []).map(({ user, profile, score }) => {
const userId = user?.id || user?._id;
const isRequested = (requestedIds || []).includes(userId);
const hobbies = (profile && Array.isArray(profile.hobbies)) ? profile.hobbies : [];
const candidateScore = typeof score === 'number' ? score : 50;
return (
<div key={userId || user?.name} className="bento-card p-6 flex flex-col justify-between relative overflow-hidden group">
{/* Score Tag Pill */}
<div className="absolute top-4 right-4 px-3 py-1 rounded-full theme-badge-amber flex items-center gap-1.5 shadow-md">
<Sparkles className="w-3.5 h-3.5 text-[var(--accent-gold)]" />
<span className="text-xs font-extrabold font-mono-numbers">
{candidateScore}% Match
</span>
</div>
<div>
{/* Candidate Header */}
<div className="flex items-center gap-4 mb-4">
<img
src={user?.avatar || DATA_AVATAR_FALLBACK}
alt={user?.name || ''}
onError={handleImageError}
className="w-14 h-14 rounded-2xl object-cover ring-2 ring-[var(--brand-accent)]/30 shrink-0"
/>
<div>
<h3 className="text-base font-bold theme-text-main group-hover:theme-text-accent transition-colors font-display">{user?.name
|| 'User'}</h3>
<p className="text-xs theme-text-sub flex items-center gap-1">
<Briefcase className="w-3 h-3 theme-text-muted" />
<span>{profile?.occupation || 'Not specified'}</span>
</p>
<p className="text-[11px] theme-text-accent font-semibold flex items-center gap-1 mt-0.5">
<MapPin className="w-3 h-3 shrink-0" />
<span>{profile?.preferredLocation || 'Not specified'}</span>
</p>
</div>
</div>
{/* Bio quote */}
<p className="text-xs theme-text-sub line-clamp-2 mb-4 italic bento-card-static p-2.5 rounded-xl">
"{profile?.bio || 'No bio provided.'}"
</p>
{/* Lifestyle Attribute Metrics */}

<div className="space-y-2 text-xs mb-5">
{/* Budget Bar */}
<div className="bento-card-static p-2.5 rounded-xl flex items-center justify-between">
<span className="theme-text-muted flex items-center gap-1 text-[11px]">
<DollarSign className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> Max Rent:
</span>
<span className="font-bold text-[var(--accent-emerald)] font-mono-numbers text-xs">
₹{(profile?.budget?.[1] || 0).toLocaleString()} / mo
</span>
</div>
{/* Food & Sleep Split */}
<div className="grid grid-cols-2 gap-2 text-[11px]">
<div className="bento-card-static p-2.5 rounded-xl">
<span className="theme-text-muted block text-[10px]">Diet:</span>
<span className="font-bold theme-text-main flex items-center gap-1 mt-0.5">
<Utensils className="w-3 h-3 theme-text-accent" /> {profile?.foodPref || 'Not specified'}
</span>
</div>
<div className="bento-card-static p-2.5 rounded-xl">
<span className="theme-text-muted block text-[10px]">Sleep:</span>
<span className="font-bold theme-text-main flex items-center gap-1 mt-0.5">
<Moon className="w-3 h-3 text-[var(--accent-gold)]" /> {profile?.sleepSchedule || 'Flexible'}
</span>
</div>
</div>
{/* Hobbies Badges */}
<div className="flex flex-wrap gap-1.5 pt-1">
{(hobbies || []).map((h, i) => (
<span key={i} className="text-[10px] theme-btn-secondary px-2 py-0.5 rounded-md font-medium">
#{h}
</span>
))}
</div>
</div>
</div>
{/* Actions */}
<div className="flex items-center gap-2 pt-2 border-t border-[var(--surface-border)]">
<button
onClick={() => setSelectedCandidate({ user, profile: profile || {}, score: candidateScore })}
className="flex-1 py-2.5 rounded-xl theme-btn-secondary text-xs font-semibold flex items-center justify-center gap-1.5 transition-
all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Eye className="w-3.5 h-3.5 text-[var(--brand-accent)]" />
<span>Breakdown</span>
</button>
<button
onClick={() => handleSendMatch(userId)}
disabled={isRequested}
className={`flex-1 py-2.5 rounded-xl text-xs font-semibold flex items-center justify-center gap-1.5 transition-all duration-200
hover:-translate-y-0.5 active:scale-95 ${
isRequested
? 'theme-btn-secondary opacity-70 cursor-not-allowed text-[var(--accent-emerald)]'
: 'gradient-btn'
}`}
>
{isRequested ? (
<>
<UserCheck className="w-3.5 h-3.5 text-[var(--accent-emerald)]" />
<span>Requested</span>
</>
) : (
<>
<Send className="w-3.5 h-3.5" />
<span>Send Request</span>
</>
)}
</button>
</div>
</div>
);
})
)}

</div>
{/* Deep Analytics Compatibility Breakdown Modal */}
{selectedCandidate && (
<div className="fixed inset-0 z-50 bg-black/80 ba ckdrop-blur-sm flex items-center justify-center p-4">
<div className="max-w-md w-full glass-panel p-6 sm:p-8 rounded-3xl border border-[var(--surface-border-accent)] shadow-2xl relative
animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
<button
onClick={() => setSelectedCandidate(null)}
className="absolute top-4 right-4 theme-text-muted hover:theme-text-main p-1 transition-all duration-200 hover:-translate-y-0.5
active:scale-95"
aria-label="Close"
>
<X className="w-5 h-5" />
</button>
<div className="flex items-center gap-4 mb-6">
<img
src={selectedCandidate.user?.avatar || DATA_AVATAR_FALLBACK}
onError={handleImageError}
className="w-16 h-16 rounded-2xl object-cover ring-2 ring-[var(--brand-accent)]"
alt=""
/>
<div>
<h3 className="text-xl font-bold theme-text-main font-display">{selectedCandidate.user?.name || 'Candidate'}</h3>
<p className="text-xs theme-text-accent font-medium">{selectedCandidate.profile?.occupation || 'Not specified'}</p>
<p className="text-[11px] theme-text-muted">{selectedCandidate.profile?.preferredLocation || 'Not specified'}</p>
</div>
</div>
{/* Score Ring Banner */}
<div className="mb-6 p-4 rounded-2xl bento-card-static text-center border border-[var(--surface-border-accent)]">
<span className="text-3xl font-extrabold theme-text-accent font-mono-numbers block">
{selectedCandidate.score || 50}% Overall Compatibility
</span>
<p className="text-[11px] theme-text-muted mt-1">Weighted against your profile preferences</p>
</div>
{/* Dimensional Breakdown */}
<div className="space-y-3 text-xs mb-6">
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Budget Overlap (25% Weight)</span>
<span className="text-[var(--accent-emerald)] font-mono-numbers">High Alignment</span>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--accent-emerald)] w-[95%]"></div>
</div>
</div>
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Dietary Match (20% Weight)</span>
<span className="theme-text-accent">
{userProfile?.foodPref && selectedCandidate.profile?.foodPref && userProfile.foodPref === selectedCandidate.profile.foodPref
? 'Exact Match (100%)'
: 'Compatible (75%)'}
</span>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--brand-accent)] w-[85%]"></div>
</div>
</div>
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Sleep Rhythm (20% Weight)</span>
<span className="text-[var(--accent-gold)] font-mono-numbers">{selectedCandidate.profile?.sleepSchedule || 'Flexible'}</span>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--accent-gold)] w-[90%]"></div>
</div>
</div>
<div className="bento-card-static p-3 rounded-xl space-y-1">
<div className="flex justify-between items-center font-semibold">
<span className="theme-text-sub">Cleanliness Rating (15% Weight)</span>
<div className="flex items-center gap-0.5">
{Array.from({ length: 5 }).map((_, i) => (

<Star
key={i}
className={`w-3 h-3 ${
i < Math.max(1, Math.min(5, Number(s electedCandidate.profile?.cleanliness) || 4))
? 'text-amber-400 fill-amber-400'
: 'text-slate-500/30'
}`}
/>
))}
</div>
</div>
<div className="w-full h-1.5 bento-card-static rounded-full overflow-hidden">
<div className="h-full bg-[var(--accent-gold)] w-[80%]"></div>
</div>
</div>
</div>
<button
onClick={() => {
handleSendMatch(selectedCandidate.user?.id || selectedCandidate.user?._id);
setSelectedCandidate(null);
}}
className="w-full py-3 gradient-btn text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2 transition-all
duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Send className="w-4 h-4" />
<span>Send Roommate Request Now</span>
</button>
</div>
</div>
)}
</div>
);
}

Module 2 –
Frontend
import React, { useState, useEffect } fro m 'react';
import {
User, Briefcase, MapPin, DollarSign, Utensils, Moon, Sparkles, Heart, CheckCircle2, Save, Cigarette,
Star, ShieldCheck
} from 'lucide-react';
import { apiService } from '../services/api';
import { sanitizeInput } from '../utils/sanitizer';
export default function ProfilePage({ user, onProfileUpdated }) {
const [occupation, setOccupation] = useState('');
const [minBudget, setMinBudget] = useState('');
const [maxBudget, setMaxBudget] = useState('');
const [foodPref, setFoodPref] = useState('Veg');
const [sleepSchedule, setSleepSchedule] = useState('Flexible');
const [cleanliness, setCleanliness] = useState(3);
const [smokingDrinking, setSmokingDrinking] = useState('Non-Smoker / Non-Drinker');
const [preferredLocation, setPreferredLocation] = useState('');
const [bio, setBio] = useState('');
const [hobbiesInput, setHobbiesInput] = useState('');
const [savedSuccess, setSavedSuccess] = useState(false);
const [isSaving, setIsSaving] = useState(false);
useEffect(() => {
const userId = user?.id || user?._id;
if (!userId) return;
let isMounted = true;
const loadProfile = async () => {
try {
const profile = await apiService.getProfile(userId);
if (isMounted && profile) {
if (profile.occupation) setOccupation(profile.occupation);
if (profile.budget && Array.isArray(profile.budget)) {
setMinBudget(profile.budget[0] ?? '');
setMaxBudget(profile.budget[1] ?? '');
}
if (profile.foodPref) setFoodPref(profile.foodPref);
if (profile.sleepSchedule) setSleepSchedule(profile.sleepSchedule);
if (profile.cleanliness !== undefined && profile.cleanliness !== null) {
setCleanliness(profile.cleanliness);
}
if (profile.smokingDrinking) setSmokingDrinking(profile.smokingDrinking);
if (profile.preferredLocation) setPreferredLocation(profile.preferredLocation);
if (profile.bio) setBio(profile.bio);
if (profile.hobbies) {
setHobbiesInput(Array.isArray(profile.hobbies) ? profile.hobbies.join(', ') : profile.hobbies);
}
}
} catch (err) {
console.error("Failed to fetch profile:", err);
}
};
loadProfile();
return () => { isMounted = false; };
}, [user?.id, user?._id]);

const handleSave = async (e) => {
e.preventDefault();
const userId = user?.id || user?._id;
if (!userId) {
console.warn("No user ID available for profile update");
return;
}
const rawHobbies = typeof hobbiesInput === 'string'
? hobbiesInput.split(',').map(s => s.trim()).filter(Boolean)
: (Array.isArray(hobbiesInput) ? hobbiesInput : []);
const hobbiesArray = rawHobbies.map(h => sanitizeInput(h)).filter(Boolean);
const profilePayload = {
occupation: sanitizeInput(occupation) || '',
budget: [Number(minBudget) || 0, Number(maxBudget) || 0],
foodPref: sanitizeInput(foodPref) || 'Veg',
sleepSchedule: sanitizeInput(sleepSchedule) || 'Flexible',
cleanliness: Number(cleanliness) || 3,
smokingDrinking: sanitizeInput(smokingDrinking) || 'Non-Smoker / Non-Drinker',
preferredLocation: sanitizeInput(preferredLocation) || '',
bio: sanitizeInput(bio, { allowMultiline: true }),
hobbies: hobbiesArray
};
setIsSaving(true);
setSavedSuccess(false);
try {
const res = await apiService.updateProfile(userId, profilePayload);
const updatedProfile = res?.profile || res || profilePayload;
setSavedSuccess(true);
const fullUpdatedUser = {
...user,
...updatedProfile,
id: userId,
_id: userId
};
if (onProfileUpdated) {
onProfileUpdated(fullUpdatedUser);
}
setTimeout(() => setSavedSuccess(false), 3000);
} catch (err) {
console.error("Error updating profile:", err);
} finally {
setIsSaving(false);
}
};
const cleanStarCount = Math.max(1, Math.min(5, Math.round(Number(cleanliness)) || 1));
return (
<div className="max-w-5xl mx-auto py-8 px-4 space-y-8">
{/* Header Banner */}
<div className="bento-card p-6 sm:p-8 flex flex-col sm:flex-row items-start sm:items-center
justify-between gap-6">
<div>
<span className="text-xs font-bold uppercase tracking-widest theme-text-accent">
Lifestyle Profile Setup
</span>

<h1 className="text-3xl font-extrabold theme-text-main font-display flex items-center gap-2">
<span>Profile & Preferences</span>
<Sparkles className="w-6 h-6 t ext-[var(--accent-gold)]" />
</h1>
<p className="theme-text-sub text-xs mt-1 max-w-xl">
Your preferences feed into the Weighted AI Compatibility Engine to connect you with like-
minded roommates.
</p>
</div>
{savedSuccess && (
<div className="flex items-center gap-2 px-4 py-2.5 rounded-xl theme-badge-emerald text-xs
font-bold shrink-0 animate-bounce">
<CheckCircle2 className="w-4 h-4 text-[var(--accent-emerald)]" />
<span>Profile Saved!</span>
</div>
)}
</div>
<form onSubmit={handleSave} className="grid grid-cols-1 lg:grid-cols-12 gap-8">
{/* Left Column: Avatar & Summary Card (4 Cols on Large) */}
<div className="lg:col-span-4 space-y-6">
<div className="bento-card p-6 flex flex-col items-center text-center space-y-4 transition-all
duration-200 hover:-translate-y-0.5">
<div className="relative">
{user?.avatar ? (
<img
src={user.avatar}
alt={user?.name || 'User'}
className="w-28 h-28 rounded-3xl object-cover ring-4 ring-[var(--brand-accent)]/30
shadow-xl"
/>
) : (
<div className="w-28 h-28 rounded-3xl bg-[var(--brand-primary)]/20 text-[var(--brand-
accent)] font-bold flex items-center justify-center text-3xl shadow-xl">
{user?.name ? user.name.charAt(0).toUpperCase() : 'U'}
</div>
)}
<span className="w-4 h-4 rounded-full bg-[var(--accent-emerald)] absolute bottom-1 right-1
ring-2 ring-[var(--surface-card)]" title="Active Seeker"></span>
</div>
<div>
<h2 className="text-xl font-bold theme-text-main font-display">{user?.name || 'User'}</h2>
<span className="text-xs theme-text-accent font-medium block mt-0.5">{user?.email ||
''}</span>
<span className="inline-block mt-2 text-[10px] uppercase font-bold theme-badge-primary
px-2.5 py-0.5 rounded-full">
{user?.role || 'user'} Account
</span>
</div>
<div className="w-full bento-card-static p-4 text-left text-xs space-y-3">
<div className="flex items-center gap-2.5 theme-text-sub">
<Briefcase className="w-4 h-4 text-[var(--brand-accent)] shrink-0" />
<span className="truncate">{occupation || 'Occupation Not Specified'}</span>
</div>
<div className="flex items-center gap-2.5 theme-text-sub">

<MapPin className="w-4 h-4 text-[var(--accent-gold)] shrink-0" />
<span className="truncate">{preferredLocation || 'Location Not Specified'}</span>
</div>
<div className="flex items-center gap-2.5 theme-text-sub">
<DollarSign className="w-4 h-4 text-[var(--accent-emerald)] shrink-0" />
<span className="font-mono-numbers font-bold text-xs">
₹{Number(minBudget || 0).toLocaleString()} - ₹{Number(maxBudget || 0).toLocaleString()}
/ mo
</span>
</div>
</div>
<button
type="submit"
disabled={isSaving}
className="w-full py-3.5 gradient-btn flex items-center justify-center gap-2 text-xs
uppercase font-bold tracking-wider shadow-lg transition-all duration-200 hover:-translate-y-0.5
active:scale-95 disabled:opacity-50"
>
<Save className="w-4 h-4" />
<span>{isSaving ? 'Saving...' : 'Save Changes'}</span>
</button>
</div>
</div>
{/* Right Column: Detailed Preferences Matrix (8 Cols on Large) */}
<div className="lg:col-span-8 space-y-6">
{/* Bento Card 1: Personal & Location Details */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<User className="w-4 h-4 text-[var(--brand-accent)]" />
<span>Personal Information</span>
</h3>
<div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Occupation</label>
<input
type="text"
value={occupation}
onChange={(e) => setOccupation(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
placeholder="e.g. Software Engineer"
/>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Preferred
Location</label>
<input
type="text"
value={preferredLocation}
onChange={(e) => setPreferredLocation(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
placeholder="e.g. HSR Layout, Bangalore"

/>
</div>
</div>
</div>
{/* Bento Card 2: Budget Range */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<div className="flex items-center justify-between">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<DollarSign className="w-4 h-4 text-[var(--accent-emerald)]" />
<span>Monthly Rent Budget Range</span>
</h3>
<span className="text-xs font-bold text-[var(--accent-emerald)] font-mono-numbers">
₹{Number(minBudget || 0).toLocaleString()} - ₹{Number(maxBudget || 0).toLocaleString()}
</span>
</div>
<div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Min Budget (₹ /
mo)</label>
<input
type="number"
step="1000"
value={minBudget}
onChange={(e) => setMinBudget(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none font-mono-numbers focus:border-
[var(--brand-accent)] transition-all duration-200"
placeholder="10000"
/>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Max Budget (₹ /
mo)</label>
<input
type="number"
step="1000"
value={maxBudget}
onChange={(e) => setMaxBudget(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none font-mono-numbers focus:border-
[var(--brand-accent)] transition-all duration-200"
placeholder="25000"
/>
</div>
</div>
</div>
{/* Bento Card 3: Lifestyle Habits Grid */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<Sparkles className="w-4 h-4 text-[var(--accent-gold)]" />
<span>Lifestyle Habits & Preferences</span>
</h3>
<div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
<div>

<label className="block text-xs font-semibold theme-text-sub mb-1.5">Dietary
Preference</label>
<select
value={foodPref}
onChange={(e) => setFoodPref(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
>
<option value="Veg">Vegetarian</option>
<option value="Non-Veg">Non-Vegetarian</option>
<option value="Vegan">Vegan</option>
<option value="Jain">Jain</option>
</select>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Sleep
Schedule</label>
<select
value={sleepSchedule}
onChange={(e) => setSleepSchedule(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
>
<option value="Early Bird">Early Bird (10 PM - 6 AM)</option>
<option value="Night Owl">Night Owl (1 AM - 8 AM)</option>
<option value="Flexible">Flexible Schedule</option>
</select>
</div>
{/* Cleanliness Slider */}
<div className="sm:col-span-2 space-y-2">
<div className="flex justify-between items-center text-xs">
<label className="font-semibold theme-text-sub">
Cleanliness Expectations Level
</label>
<span className="font-bold text-[var(--accent-gold)] font-mono-numbers flex items-center
gap-1.5">
<span>{cleanliness} / 5</span>
<div className="flex items-center gap-0.5">
{Array.from({ length: 5 }).map((_, i) => (
<Star
key={i}
className={`w-3 h-3 ${
i < cleanStarCount
? 'text-amber-400 fill-amber-400'
: 'text-slate-500/30'
}`}
/>
))}
</div>
</span>
</div>
<div className="bento-card-static p-3 flex items-center gap-3">
<input
type="range"

min="1"
max="5"
value={cleanliness}
onChange={(e) => setCleanliness(e.target.value)}
className="w-full accent-[var(--brand-accent)] cursor-pointer"
/>
</div>
</div>
<div className="sm:col-span-2">
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Smoking &
Drinking Habits</label>
<select
value={smokingDrinking}
onChange={(e) => setSmokingDrinking(e.target.value)}
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
>
<option value="Non-Smoker / Non-Drinker">Non-Smoker & Non-Drinker</option>
<option value="Non-Smoker / Social Drinker">Non-Smoker / Social Drinker</option>
<option value="Social Smoker / Social Drinker">Social Smoker & Social Drinker</option>
</select>
</div>
</div>
</div>
{/* Bento Card 4: Bio & Hobbies */}
<div className="bento-card p-6 space-y-4 transition-all duration-200 hover:-translate-y-0.5">
<h3 className="text-sm font-bold theme-text-main uppercase tracking-wider flex items-
center gap-2 font-display">
<Heart className="w-4 h-4 text-rose-500 dark:text-rose-400" />
<span>Bio & Hobbies</span>
</h3>
<div className="space-y-4">
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Hobbies & Interests
(Comma Separated)</label>
<input
type="text"
value={hobbiesInput}
onChange={(e) => setHobbiesInput(e.target.value)}
placeholder="e.g. Coding, Badminton, Reading, Gaming"
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"
/>
</div>
<div>
<label className="block text-xs font-semibold theme-text-sub mb-1.5">Bio /
Description</label>
<textarea
rows="3"
value={bio}
onChange={(e) => setBio(e.target.value)}
placeholder="Write a brief introduction about yourself..."
className="w-full theme-input p-3 text-xs outline-none focus:border-[var(--brand-accent)]
transition-all duration-200"

></textarea>
</div>
</div>
</div>
</div>
</form>
</div>
);
}
Backend
import mongoose from 'mongoose';
const profileSchema = new mongoose.Schema({
userId: { type: String, required: true, index: true },
occupation: { type: String, default: 'Student / Professional' },
budget: { type: [Number], default: [10000, 25000] },
foodPref: { type: String, default: 'Veg' },
sleepSchedule: { type: String, default: 'Early Bird' },
cleanliness: { type: Number, min: 1, max: 5, default: 4 },
smokingDrinking: { type: String, default: 'Non-Smoker / Non-Drinker' },
hobbies: [{ type: String }],
preferredLocation: { type: String, default: 'Koramangala, Bangalore' },
bio: { type: String, default: 'Looking for a compatible roommate!' }
}, { timestamps: true });
export const Profile = mongoose.model('Profile', profileSchema);

Module 3 - Accommodation & Room Listing
Frontend
Property.jsx
import React, { useState, useEffect, useRef } from 'react';
import { Home, MapPin, Search, Filter, Plus, Check, Calendar, ShieldCheck, Phone, X, Eye, Users, RefreshCw,
CheckCircle2, Building, Sparkles, ShieldAlert } from 'lucide-react';
import { apiService } from '../services/api';
const DATA_PROPERTY_FALLBACK = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg'
width='400' height='250' viewBox='0 0 24 24' fill='%231f2937' stroke='%239ca3af' stroke-width='1.5'><rect
width='100%' height='100%' fill='%23374151'/><path d='m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z'/><polyline
points='9 22 9 12 15 12 15 22'/></svg>";
export default function PropertiesPage({ currentUser }) {
const [properties, setProperties] = useState([]);
const [loading, setLoading] = useState(true);
const [searchTerm, setSearchTerm] = useState('');
const [locationFilter, setLocationFilter] = useState('');
const [typeFilter, setTypeFilter] = useState('All');
const [sharingFilter, setSharingFilter] = useState('All');
const [maxBudget, setMaxBudget] = useState(30000);
const [selectedProperty, setSelectedProperty] = useState(null);
const [activeModalTab, setActiveModalTab] = useState('details'); // 'details' | 'book'
const [selectedImageIndex, setSelectedImageIndex] = useState(0);
const [bookingDate, setBookingDate] = useState(new Date().toISOString().split('T')[0]);
const [bookingTimeSlot, setBookingTimeSlot] = useState('10:00 AM - 12:00 PM');
const [bookingConfirmed, setBookingConfirmed] = useState(false);
const [bookingError, setBookingError] = useState('');
const [showAddModal, setShowAddModal] = useState(false);
// Form states for Add Property
const [newTitle, setNewTitle] = useState('');
const [newLocation, setNewLocation] = useState('');
const [newPrice, setNewPrice] = useState('');
const [newType, setNewType] = useState('Flat');
const [newSharingType, setNewSharingType] = useState('Private Room in Shared Flat');
const [newDesc, setNewDesc] = useState('');
const [newImageUrls, setNewImageUrls] = useState('');
const [selectedAmenities, setSelectedAmenities] = useState([]);
const [addPropertyError, setAddPropertyError] = useState('');
const [isSubmitting, setIsSubmitting] = useState(false);
const availableAmenities = ['WiFi', 'AC', 'Power Backup', 'Washing Machine', 'Housekeeping', 'Gym', 'Balcony',
'Biometric Lock', 'Security 24/7', '3 Meals Daily'];
const isMounted = useRef(true);
const bookingTimeoutRef = useRef(null);
useEffect(() => {
isMounted.current = true;
const fetchProperties = async () => {
try {
if (isMounted.current) setLoading(true);
const data = await apiService.getProperties().catch(() => []);
if (isMounted.current) {
setProperties(Array.isArray(data) ? data : []);
}
} catch (err) {
console.error('Failed to fetch properties:', err);
} finally {
if (isMounted.current) {
setLoading(false);
}
}
};
fetchProperties();
return () => {
isMounted.current = false;
if (bookingTimeoutRef.current) {
clearTimeout(bookingTimeoutRef.current);
}

};
}, []);
const handleImageError = (e) => {
e.target.onerror = null;
e.target.src = DATA_PROPERTY_FALLBACK;
};
const handleToggleAmenity = (amenity) => {
if ((selectedAmenities || []).includes(amenity)) {
setSelectedAmenities((selectedAmenities || []).filter(a => a !== amenity));
} else {
setSelectedAmenities([...(selectedAmenities || []), amenity]);
}
};
const hasActiveFilters = searchTerm || locationFilter || typeFilter !== 'All' || sharingFilter !== 'All' || maxBudget < 30000;
const resetFilters = () => {
setSearchTerm('');
setLocationFilter('');
setTypeFilter('All');
setSharingFilter('All');
setMaxBudget(30000);
};
const filteredProps = (properties || []).filter(p => {
if (!p) return false;
const matchesSearch = (p.title || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
(p.location || '').toLowerCase().includes((searchTerm || '').toLowerCase()) ||
(p.description || '').toLowerCase().includes((searchTerm || '').toLowerCase());
const matchesLoc = !locationFilter || (p.location || '').toLowerCase().includes((locationFilter || '').toLowerCase());
const matchesBudget = typeof p.price === 'number' ? p.price <= maxBudget : true;
const matchesType = typeFilter === 'All' || p.type === typeFilter;
const matchesSharing = sharingFilter === 'All' || (p.sharingType &&
p.sharingType.toLowerCase().includes((sharingFilter || '').toLowerCase()));
return matchesSearch && matchesLoc && matchesBudget && matchesType && matchesSharing;});
const openPropertyModal = (prop, tab = 'details') => {
setSelectedProperty(prop);
setActiveModalTab(tab);
setSelectedImageIndex(0);
setBookingConfirmed(false);
setBookingError('');
};
const closePropertyModal = () => {
if (bookingTimeoutRef.current) {
clearTimeout(bookingTimeoutRef.current);
}
setSelectedProperty(null);
setSelectedImageIndex(0);
setBookingConfirmed(false);
setBookingError('');
setActiveModalTab('details');
};
const resetAddPropertyForm = () => {
setNewTitle('');
setNewLocation('');
setNewPrice('');
setNewType('Flat');
setNewSharingType('Private Room in Shared Flat');
setNewDesc('');
setNewImageUrls('');
setSelectedAmenities([]);
setAddPropertyError('');
};
const openAddModal = () => {
resetAddPropertyForm();
setShowAddModal(true);
};
const closeAddModal = () => {

resetAddPropertyForm();
setShowAddModal(false);
};
const handleBookVisit = async (e) => {
e.preventDefault();
setBookingError('');
if (!selectedProperty) return;
if (!bookingDate) {
setBookingError('Please select a visit date.');
return;
}
const userId = currentUser?.id || currentUser?._id || 'usr_guest';
const propId = selectedProperty.id || selectedProperty._id;
try {
await apiService.bookProperty(propId, userId, bookingDate);
if (!isMounted.current) return;
setBookingConfirmed(true);
bookingTimeoutRef.current = setTimeout(() => {
if (isMounted.current) {
closePropertyModal();
}
}, 2400);
} catch (err) {
if (!isMounted.current) return;
console.error('Failed to book property visit:', err);
setBookingError(err.response?.data?.error || err.message || 'Failed to schedule visit. Please try again.');
}
};
const handleAddPropertySubmit = async (e) => {
e.preventDefault();
setAddPropertyError('');
const trimmedTitle = (newTitle || '').trim();
const trimmedLocation = (newLocation || '').trim();
const parsedPrice = Number(newPrice);
if (!trimmedTitle) {
setAddPropertyError('Please enter a property title.');
return;
}
if (trimmedTitle.length < 3) {
setAddPropertyError('Property title must be at least 3 characters.');
return;
}
if (!trimmedLocation) {
setAddPropertyError('Please enter a location/address.');
return;
}
if (!newPrice || isNaN(parsedPrice) || parsedPrice <= 0) {
setAddPropertyError('Please enter a valid monthly rent (greater than 0).');
return;
}
const imageList = (newImageUrls || '')
.split(',')
.map(url => url.trim())
.filter(url => url.startsWith('http://') || url.startsWith('https://'));
const ownerId = currentUser?.id || currentUser?._id || '';
setIsSubmitting(true);
try {
const created = await apiService.addProperty({
title: trimmedTitle,
location: trimmedLocation,
price: parsedPrice,
type: newType,
sharingType: newSharingType,
description: (newDesc || '').trim() || 'Spacious modern co-living accommodation.',
amenities: (selectedAmenities || []).length ? selectedAmenities : ['WiFi', 'Power Backup'],

images: imageList.length ? imageList : ['https://images.unsplash.com/photo-1522708323590-
d24dbb6b0267?auto=format&fit=crop&w=800&q=80'],
ownerName: currentUser?.name || 'Property Owner',
ownerContact: currentUser?.email || '',
ownerId
});
if (!isMounted.current) return;
if (created) {
setProperties(prev => [created, ...(prev || [])]);
}
closeAddModal();
} catch (err) {
if (!isMounted.current) return;
console.error('Failed to add property listing:', err);
setAddPropertyError(err.response?.data?.error || err.message || 'Failed to publish property listing.');
} finally {
if (isMounted.current) {
setIsSubmitting(false);
}
}
};
if (loading) {
return (
<div className="max-w-7xl mx-auto py-12 px-4 flex flex-col items-center justify-center min-h-[400px]">
<Home className="w-8 h-8 text-[var(--brand-accent)] animate-spin mb-3" />
<p className="text-sm theme-text-sub font-medium">Loading property listings...</p>
</div>
);
}
return (
<div className="max-w-7xl mx-auto py-8 px-4 sm:px-6">
{/* Header Section */}
<div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 mb-8">
<div>
<div className="flex items-center gap-2 mb-1">
<span className="px-2.5 py-0.5 rounded-full theme-badge-primary text-[11px] font-bold uppercase tracking-
wider">
Verified Co-Living & PGs
</span>
<span className="text-xs theme-text-muted font-mono-numbers">
{(filteredProps || []).length} Available
</span>
</div>
<h1 className="text-3xl sm:text-4xl font-extrabold theme-text-main flex items-center gap-3 font-display tracking-
tight">
Property Listings <Home className="w-7 h-7 text-[var(--brand-accent)]" />
</h1>
<p className="theme-text-sub text-sm mt-1 max-w-xl">
Explore curated, verified PGs and shared flats with zero brokerage and instant site visit scheduling.
</p>
</div>
<button
onClick={openAddModal}
className="gradient-btn px-5 py-3 text-xs sm:text-sm font-bold flex items-center gap-2 rounded-xl shadow-lg
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Plus className="w-4 h-4" />
<span>Add Property Listing</span>
</button>
</div>
{/* Clean Search & Filter Header Bar */}
<div className="bento-card-static p-4 sm:p-6 mb-8 shadow-md rounded-2xl border border-[var(--surface-border)]">
<div className="flex items-center justify-between mb-4">
<h2 className="text-sm font-bold theme-text-main flex items-center gap-2 font-display">
<Filter className="w-4 h-4 theme-text-accent" /> Search & Filter Properties

</h2>
{hasActiveFilters && (
<button
onClick={resetFilters}
className="text-xs theme-text-accent hover:underline flex items-center gap-1 font-medium transition-all
duration-200 active:scale-95"
>
<RefreshCw className="w-3 h-3" /> Reset Filters
</button>
)}
</div>
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 text-xs">
{/* Search Input */}
<div className="relative">
<Search className="w-4 h-4 theme-text-muted absolute left-3.5 top-3.5" />
<input
type="text"
placeholder="Search title, location, or area..."
value={searchTerm}
onChange={(e) => setSearchTerm(e.target.value)}
className="w-full theme-input py-2.5 pl-10 pr-3.5 text-xs outline-none rounded-xl"
/>
</div>
{/* Location Dropdown */}
<div className="relative">
<select
value={locationFilter}
onChange={(e) => setLocationFilter(e.target.value)}
className="w-full theme-input py-2.5 px-3.5 text-xs outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="">All Locations</option>
<option value="Koramangala">Koramangala, Bangalore</option>
<option value="HSR Layout">HSR Layout, Bangalore</option>
<option value="Indiranagar">Indiranagar, Bangalore</option>
<option value="Whitefield">Whitefield, Bangalore</option>
<option value="BTM Layout">BTM Layout, Bangalore</option>
</select>
<MapPin className="w-3.5 h-3.5 theme-text-muted absolute right-3 top-3.5 pointer-events-none" />
</div>
{/* Property Type Filter */}
<div className="relative">
<select
value={typeFilter}
onChange={(e) => setTypeFilter(e.target.value)}
className="w-full theme-input py-2.5 px-3.5 text-xs outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="All">All Property Types (PG & Flat)</option>
<option value="Flat">Shared Flat / Apartment</option>
<option value="PG">Co-Living PG</option>
</select>
<Building className="w-3.5 h-3.5 theme-text-muted absolute right-3 top-3.5 pointer-events-none" />
</div>
{/* Sharing Type Filter */}
<div className="relative">
<select
value={sharingFilter}
onChange={(e) => setSharingFilter(e.target.value)}
className="w-full theme-input py-2.5 px-3.5 text-xs outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="All">All Sharing Types</option>
<option value="Private">Private Room</option>
<option value="Twin">Twin / Double Sharing</option>
<option value="Single">Single Bedroom</option>
</select>
<Users className="w-3.5 h-3.5 theme-text-muted absolute right-3 top-3.5 pointer-events-none" />

</div>
</div>
{/* Rent Slider Bar */}
<div className="mt-4 pt-4 border-t border-[var(--surface-border)] flex flex-col sm:flex-row sm:items-center justify-
between gap-3 text-xs">
<div className="flex items-center gap-3">
<span className="theme-text-sub font-semibold">Max Rent Budget:</span>
<span className="px-3 py-1 rounded-lg bento-card-static text-[var(--accent-emerald)] font-extrabold font-mono-
numbers text-sm">
₹{maxBudget.toLocaleString()} / mo
</span>
</div>
<div className="flex items-center gap-3 flex-1 max-w-md">
<span className="theme-text-muted font-mono-numbers">₹8k</span>
<input
type="range"
min="8000"
max="35000"
step="1000"
value={maxBudget}
onChange={(e) => setMaxBudget(Number(e.target.value))}
className="w-full accent-[var(--brand-accent)] cursor-pointer h-2 bento-card-static rounded-lg"
/>
<span className="theme-text-muted font-mono-numbers">₹35k</span>
</div>
</div>
</div>
{/* Properties Bento Grid */}
{(filteredProps || []).length === 0 ? (
<div className="bento-card-static p-12 text-center rounded-3xl">
<Home className="w-12 h-12 text-[var(--brand-accent)] mx-auto mb-3 opacity-50" />
<h3 className="text-lg font-bold theme-text-main font-display mb-1">No Matching Properties Found</h3>
<p className="theme-text-sub text-xs mb-4">Try adjusting your price range or clearing location filters.</p>
<button
onClick={resetFilters}
className="theme-btn-secondary px-4 py-2 text-xs font-semibold transition-all duration-200 hover:-translate-y-
0.5 active:scale-95"
>
Clear All Filters
</button>
</div>
) : (
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
{(filteredProps || []).map(prop => (
<div
key={prop?.id || prop?._id || prop?.title}
className="bento-card overflow-hidden flex flex-col justify-between group rounded-2xl border border-[var(--
surface-border)] hover:border-[var(--surface-border-accent)] transition-all duration-300 shadow-sm"
>
<div>
{/* Hero Image with Aspect Ratio */}
<div className="relative aspect-[16/10] overflow-hidden bg-[var(--surface-card)]">
<img
src={prop?.images?.[0] || 'https://images.unsplash.com/photo-1522708323590-
d24dbb6b0267?auto=format&fit=crop&w=800&q=80'}
alt={prop?.title || ''}
onError={handleImageError}
className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"
/>
<div className="absolute inset-0 bg-black/30 pointer-events-none" />
{/* Overlays */}
<div className="absolute top-3 left-3 flex flex-wrap gap-1.5 items-center">

<span className="px-2.5 py-1 rounded-full glass-panel text-[11px] font-bold theme-text-accent border
border-[var(--surface-border-accent)] backdrop-blur-md">
{prop?.type || 'PG'} • {prop?.sharingType || 'Shared'}
</span>
</div>
<div className="absolute top-3 right-3">
<span className="px-2.5 py-1 rounded-full theme-badge-emerald text-[10px] font-bold flex items-center gap-
1 shadow-md">
<ShieldCheck className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> Verified
</span>
</div>
{(prop?.images || []).length > 1 && (
<span className="absolute bottom-3 right-3 px-2 py-0.5 rounded-md glass-panel text-[10px] font-mono-
numbers theme-text-main">
+{(prop.images || []).length - 1} photos
</span>
)}
</div>
{/* Card Content */}
<div className="p-5">
<div className="flex items-center gap-1 theme-text-accent text-xs font-semibold mb-1">
<MapPin className="w-3.5 h-3.5 shrink-0" />
<span className="line-clamp-1">{prop?.location || 'Location N/A'}</span>
</div>
<h3 className="text-base font-bold theme-text-main mb-2 group-hover:theme-text-accent transition-colors
line-clamp-1 font-display">
{prop?.title || 'Untitled Property'}
</h3>
<p className="text-xs theme-text-sub line-clamp-2 leading-relaxed mb-4">
{prop?.description || ''}
</p>
{/* Amenities Micro Pills */}
<div className="flex flex-wrap gap-1.5 mb-4">
{(prop?.amenities || []).slice(0, 4).map((amenity, idx) => (
<span key={idx} className="px-2.5 py-1 rounded-lg bento-card-static theme-text-sub text-[10px] font-
medium border border-[var(--surface-border)]">
{amenity}
</span>
))}
{(prop?.amenities || []).length > 4 && (
<span className="px-2 py-1 rounded-lg bento-card-static theme-text-muted text-[10px] font-mono-
numbers">
+{(prop.amenities || []).length - 4} more
</span>
)}
</div>
</div>
</div>
{/* Card Footer */}
<div className="p-5 pt-3 border-t border-[var(--surface-border)] flex items-center justify-between mt-auto bg-
[var(--surface-card)]">
<div>
<span className="text-[10px] theme-text-muted block font-bold uppercase tracking-wider">Rent</span>
<div className="flex items-baseline gap-1">
<span className="text-lg sm:text-xl font-extrabold text-[var(--accent-emerald)] font-mono-numbers">
₹{prop?.price?.toLocaleString() || '0'}
</span>
<span className="text-[10px] theme-text-muted">/mo</span>
</div>
</div>
<div className="flex items-center gap-2">
<button
onClick={() => openPropertyModal(prop, 'details')}
className="theme-btn-secondary px-3 py-2 text-xs font-semibold flex items-center gap-1 rounded-xl
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"

>
<Eye className="w-3.5 h-3.5" /> Details
</button>
<button
onClick={() => openPropertyModal(prop, 'book')}
className="gradient-btn px-3.5 py-2 text-xs font-semibold flex items-center gap-1 rounded-xl shadow-md
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Calendar className="w-3.5 h-3.5" /> Book
</button>
</div>
</div>
</div>
))}
</div>
)}
{/* Property Details & Book Visit Modal */}
{selectedProperty && (
<div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4 overflow-y-
auto">
<div className="max-w-3xl w-full glass-panel p-6 sm:p-8 rounded-3xl border border-[var(--surface-border-accent)]
shadow-2xl relative my-8 animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
<button
onClick={closePropertyModal}
className="absolute top-4 right-4 p-2 rounded-full bento-card-static theme-text-muted hover:theme-text-main
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<X className="w-5 h-5" />
</button>
{/* Modal Tabs Header */}
<div className="flex items-center gap-3 border-b border-[var(--surface-border)] pb-4 mb-6">
<button
onClick={() => setActiveModalTab('details')}
className={`pb-2 text-sm font-bold font-display transition-all duration-200 hover:-translate-y-0.5 active:scale-
95 relative ${
activeModalTab === 'details' ? 'theme-text-main' : 'theme-text-muted hover:theme-text-sub'
}`}
>
Property Details
{activeModalTab === 'details' && (
<span className="absolute bottom-0 left-0 right-0 h-0.5 bg-[var(--brand-accent)] rounded-full" />
)}
</button>
<button
onClick={() => setActiveModalTab('book')}
className={`pb-2 text-sm font-bold font-display transition-all duration-200 hover:-translate-y-0.5 active:scale-
95 relative flex items-center gap-1.5 ${
activeModalTab === 'book' ? 'theme-text-main' : 'theme-text-muted hover:theme-text-sub'
}`}
>
<Calendar className="w-4 h-4 text-[var(--accent-emerald)]" /> Book Site Visit
{activeModalTab === 'book' && (
<span className="absolute bottom-0 left-0 right-0 h-0.5 bg-[var(--accent-emerald)] rounded-full" />
)}
</button>
</div>
{/* Gallery Image Display */}
<div className="aspect-[16/9] rounded-2xl overflow-hidden mb-4 relative bg-[var(--surface-card)] border border-
[var(--surface-border)]">
<img
src={selectedProperty.images?.[selectedImageIndex] || selectedProperty.images?.[0] ||
'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80'}
onError={handleImageError}
className="w-full h-full object-cover"
alt={selectedProperty.title || ''}

/>
<div className="absolute bottom-3 left-3 glass-panel px-3 py-1.5 rounded-xl text-xs font-bold theme-text-main
font-mono-numbers border border-[var(--surface-border-accent)]">
₹{selectedProperty.price?.toLocaleString() || '0'} / month
</div>
<div className="absolute top-3 right-3">
<span className="px-3 py-1 rounded-full theme-badge-emerald text-xs font-bold flex items-center gap-1
shadow-md">
<ShieldCheck className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> Verified Listing
</span>
</div>
</div>
{/* Thumbnails Bar */}
{(selectedProperty.images || []).length > 1 && (
<div className="flex gap-2 mb-6 overflow-x-auto pb-2">
{(selectedProperty.images || []).map((image, idx) => (
<button
key={idx}
type="button"
onClick={() => setSelectedImageIndex(idx)}
className={`h-16 w-20 rounded-xl overflow-hidden shrink-0 border transition-all duration-200 hover:-
translate-y-0.5 active:scale-95 ${
idx === selectedImageIndex ? 'border-[var(--brand-accent)] ring-2 ring-[var(--brand-glow)]' : 'border-[var(--
surface-border)] opacity-70 hover:opacity-100'
}`}
>
<img
src={image}
alt={`Thumbnail ${idx + 1}`}
onError={handleImageError}
className="h-full w-full object-cover"
/>
</button>
))}
</div>
)}
{/* Content Tabs */}
{activeModalTab === 'details' ? (
<div className="space-y-6">
<div>
<h2 className="text-xl sm:text-2xl font-bold theme-text-main mb-1 font-display">
{selectedProperty.title || 'Untitled Property'}
</h2>
<p className="text-xs theme-text-accent flex items-center gap-1 font-medium">
<MapPin className="w-4 h-4" /> {selectedProperty.location || 'Location N/A'}
</p>
</div>
{/* Info Grid */}
<div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
<div className="bento-card-static p-3 text-xs">
<span className="theme-text-muted block text-[10px] uppercase font-bold">Property Type</span>
<span className="theme-text-main font-bold mt-0.5 block">{selectedProperty.type || 'Flat'}</span>
</div>
<div className="bento-card-static p-3 text-xs">
<span className="theme-text-muted block text-[10px] uppercase font-bold">Occupancy</span>
<span className="theme-text-main font-bold mt-0.5 block">{selectedProperty.sharingType || 'Shared
Room'}</span>
</div>
<div className="bento-card-static p-3 text-xs">
<span className="theme-text-muted block text-[10px] uppercase font-bold">Rent & Security</span>
<span className="theme-text-accent font-mono-numbers font-bold mt-0.5 block">
₹{selectedProperty.price?.toLocaleString() || '0'} / mo
</span>
</div>
</div>

{/* Description */}
<div>
<h4 className="text-xs font-bold theme-text-muted uppercase tracking-wider mb-2 font-display">
About Property
</h4>
<p className="text-xs theme-text-sub leading-relaxed bento-card-static p-4 rounded-xl">
{selectedProperty.description || 'No detailed description available.'}
</p>
</div>
{/* Amenities */}
<div>
<h4 className="text-xs font-bold theme-text-muted uppercase tracking-wider mb-2 font-display">
Included Amenities
</h4>
<div className="flex flex-wrap gap-2">
{(selectedProperty.amenities || []).map((amenity, idx) => (
<span key={idx} className="px-3 py-1.5 rounded-xl bento-card-static theme-text-main text-xs font-medium
border border-[var(--surface-border)] flex items-center gap-1.5">
<CheckCircle2 className="w-3.5 h-3.5 text-[var(--accent-emerald)]" /> {amenity}
</span>
))}
</div>
</div>
{/* Landlord Contact Box */}
<div className="p-4 rounded-2xl bento-card-static border border-[var(--surface-border-accent)] flex items-
center justify-between text-xs">
<div>
<span className="theme-text-main font-bold block text-sm">{selectedProperty.ownerName || 'Property
Owner'}</span>
<span className="theme-text-muted">Verified Property Partner</span>
</div>
{selectedProperty.ownerContact && (
<a
href={`tel:${selectedProperty.ownerContact}`}
className="flex items-center gap-2 theme-badge-emerald px-4 py-2 rounded-xl font-bold font-mono-
numbers transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Phone className="w-4 h-4" />
<span>{selectedProperty.ownerContact}</span>
</a>
)}
</div>
<div className="pt-2 flex justify-end">
<button
onClick={() => setActiveModalTab('book')}
className="gradient-btn px-6 py-3 text-xs font-bold rounded-xl flex items-center gap-2 transition-all
duration-200 hover:-translate-y-0.5 active:scale-95"
>
<Calendar className="w-4 h-4" /> Book Site Visit Now
</button>
</div>
</div>
) : (
/* Book Visit Form Tab */
<div className="space-y-6">
<div>
<h3 className="text-lg font-bold theme-text-main font-display mb-1">
Schedule a Visit to {selectedProperty.title || 'Property'}
</h3>
<p className="theme-text-sub text-xs">
Choose your convenient date & time slot. The property manager will guide you on site.
</p>
</div>
{bookingError && (

<div className="p-3.5 rounded-xl bg-red-500/10 border border-red-500/30 text-red-600 dark:text-red-400 text-
xs font-medium flex items-center gap-2">
<ShieldAlert className="w-4 h-4 text-red-500 shrink-0" />
<span>{bookingError}</span>
</div>
)}
{bookingConfirmed ? (
<div className="p-6 rounded-2xl theme-badge-emerald text-center space-y-2 animate-in fade-in duration-
200">
<CheckCircle2 className="w-10 h-10 text-[var(--accent-emerald)] mx-auto" />
<h4 className="text-base font-bold theme-text-main font-display">Visit Scheduled Successfully!</h4>
<p className="text-xs theme-text-sub">
Your request for <span className="font-bold text-[var(--accent-emerald)]">{bookingDate}
({bookingTimeSlot})</span> has been received. {selectedProperty.ownerName || 'Property Partner'} will reach out via call
shortly.
</p>
</div>
) : (
<form onSubmit={handleBookVisit} className="bento-card-static p-6 rounded-2xl space-y-4 text-xs">
<div>
<label className="block theme-text-sub font-semibold mb-1.5">Select Visit Date</label>
<input
type="date"
min={new Date().toISOString().split('T')[0]}
value={bookingDate}
onChange={(e) => setBookingDate(e.target.value)}
className="w-full theme-input p-3 outline-none font-mono-numbers rounded-xl"
required
/>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1.5">Preferred Time Slot</label>
<div className="grid grid-cols-1 sm:grid-cols-3 gap-2">
{['10:00 AM - 12:00 PM', '02:00 PM - 04:00 PM', '05:00 PM - 07:00 PM'].map((slot) => (
<button
key={slot}
type="button"
onClick={() => setBookingTimeSlot(slot)}
className={`p-2.5 rounded-xl border text-center font-medium font-mono-numbers transition-all
duration-200 hover:-translate-y-0.5 active:scale-95 ${
bookingTimeSlot === slot ? 'theme-badge-primary border-[var(--brand-accent)]' : 'bento-card-static
theme-text-sub'
}`}
>
{slot}
</button>
))}
</div>
</div>
<div className="p-3 rounded-xl bento-card-static text-[11px] theme-text-muted flex items-start gap-2">
<Sparkles className="w-4 h-4 text-[var(--accent-gold)] shrink-0 mt-0.5" />
<span>Zero visit fees. You can reschedule or cancel visit anytime from your notifications dashboard.</span>
</div>
<button
type="submit"
className="w-full py-3.5 gradient-btn font-bold text-xs rounded-xl shadow-lg uppercase tracking-wider
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
Confirm Visit Request
</button>
</form>
)}
</div>
)}
</div>

</div>
)}
{/* Add Property Listing Modal */}
{showAddModal && (
<div className="fixed inset-0 z-50 bg-black/80 backdrop-blur-md flex items-center justify-center p-4 overflow-y-
auto">
<div className="max-w-lg w-full glass-panel p-6 sm:p-8 rounded-3xl border border-[var(--surface-border-accent)]
shadow-2xl relative my-8 animate-in fade-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
<button
onClick={closeAddModal}
className="absolute top-4 right-4 p-2 rounded-full bento-card-static theme-text-muted hover:theme-text-main
transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
<X className="w-5 h-5" />
</button>
<div className="mb-6">
<h3 className="text-xl font-bold theme-text-main font-display mb-1 flex items-center gap-2">
<Building className="w-5 h-5 text-[var(--brand-accent)]" /> Add New Property Listing
</h3>
<p className="text-xs theme-text-sub">List your flat or PG for verified tech professionals & students.</p>
</div>
{addPropertyError && (
<div className="mb-4 p-3.5 rounded-xl bg-red-500/10 border border-red-500/30 text-red-600 dark:text-red-400
text-xs font-medium flex items-center gap-2">
<ShieldAlert className="w-4 h-4 text-red-500 shrink-0" />
<span>{addPropertyError}</span>
</div>
)}
<form onSubmit={handleAddPropertySubmit} className="space-y-4 text-xs">
<div>
<label className="block theme-text-sub font-semibold mb-1">Property Title</label>
<input
type="text"
placeholder="e.g. Luxury 2BHK Room in Koramangala 5th Block"
value={newTitle}
onChange={(e) => setNewTitle(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl"
required
/>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Location / Address</label>
<input
type="text"
placeholder="e.g. HSR Layout Sector 1, Bangalore"
value={newLocation}
onChange={(e) => setNewLocation(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl"
required
/>
</div>
<div className="grid grid-cols-2 gap-3">
<div>
<label className="block theme-text-sub font-semibold mb-1">Monthly Rent (₹)</label>
<input
type="number"
min="1"
placeholder="Enter monthly rent"
value={newPrice}
onChange={(e) => setNewPrice(e.target.value)}
className="w-full theme-input p-3 outline-none font-mono-numbers rounded-xl text-[var(--accent-emerald)]
font-bold"
required
/>
</div>

<div>
<label className="block theme-text-sub font-semibold mb-1">Property Type</label>
<select
value={newType}
onChange={(e) => setNewType(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="Flat">Shared Flat</option>
<option value="PG">Co-Living PG</option>
</select>
</div>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Sharing / Occupancy Type</label>
<select
value={newSharingType}
onChange={(e) => setNewSharingType(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl appearance-none cursor-pointer"
>
<option value="Private Room in Shared Flat">Private Room in Shared Flat</option>
<option value="Twin Sharing Room">Twin Sharing Room</option>
<option value="Single Bedroom Apartment">Single Bedroom Apartment</option>
<option value="3BHK Master Bedroom">3BHK Master Bedroom</option>
</select>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Description</label>
<textarea
rows="3"
placeholder="Describe your property, house rules, nearby metro, etc."
value={newDesc}
onChange={(e) => setNewDesc(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl resize-none"
/>
</div>
{/* Amenities Selection Pills */}
<div>
<label className="block theme-text-sub font-semibold mb-1.5">Select Amenities</label>
<div className="flex flex-wrap gap-1.5">
{(availableAmenities || []).map(amenity => {
const isSelected = (selectedAmenities || []).includes(amenity);
return (
<button
key={amenity}
type="button"
onClick={() => handleToggleAmenity(amenity)}
className={`px-2.5 py-1 rounded-lg text-[11px] font-medium flex items-center gap-1 transition-all duration-
200 hover:-translate-y-0.5 active:scale-95 ${
isSelected ? 'theme-badge-primary border-[var(--brand-accent)]' : 'bento-card-static theme-text-muted
hover:theme-text-sub'
}`}
>
{isSelected ? <Check className="w-3 h-3 text-[var(--brand-accent)]" /> : <Plus className="w-3 h-3 text-
slate-400" />}
<span>{amenity}</span>
</button>
);
})}
</div>
</div>
<div>
<label className="block theme-text-sub font-semibold mb-1">Image URLs (comma separated)</label>
<input
type="text"
placeholder="https://images.unsplash.com/..., https://..."

value={newImageUrls}
onChange={(e) => setNewImageUrls(e.target.value)}
className="w-full theme-input p-3 outline-none rounded-xl"
/>
</div>
<button
type="submit"
disabled={isSubmitting}
className="w-full py-3.5 gradient-btn disabled:opacity-50 font-bold text-xs rounded-xl uppercase tracking-
wider shadow-lg transition-all duration-200 hover:-translate-y-0.5 active:scale-95"
>
{isSubmitting ? 'Publishing...' : 'Publish Listing'}
</button>
</form>
</div>
</div>
)}
</div>
);
}
Backend
import mongoose from 'mongoose';
const propertySchema = new mongoose.Schema({
id: { type: String, index: true },
title: { type: String, required: true },
description: { type: String },
price: { type: Number, required: true },
location: { type: String, required: true },
type: { type: String, enum: ['Flat', 'PG'], default: 'Flat' },
sharingType: { type: String, default: 'Private Room in Shared Flat' },
amenities: [{ type: String }],
images: [{ type: String }],
ownerName: { type: String, required: true },
ownerContact: { type: String, required: true },
ownerId: { type: String, index: true },
userId: { type: String, index: true },
status: { type: String, enum: ['verified', 'pending', 'rejected'], default: 'verified' }
}, { timestamps: true });
export const Property = mongoose.model('Property', propertySchema);

5.2.2 Code Efficiency
Code optimization was performed to improve the execution speed, response time, memory usage, and
overall performance of the RoomieSync application. The following techniques were used:
 Code Reusability: Common functions and components are reused instead of writing the same code
multiple times.
 Efficient Database Queries: Only the required fields and records are retrieved from MongoDB instead of
loading unnecessary data.
 Reduced Database Calls: Multiple unnecessary database requests are avoided wherever possible.
 Input Validation: User inputs are validated before processing to prevent unnecessary operations and
errors.
 Efficient Matching: The roommate compatibility calculation processes only the required profile
attributes to generate the compatibility score.
 Image Optimization: Property images uploaded by owners are handled efficiently to reduce unnecessary
storage and loading time.
 Conditional Rendering: Only the required interface components and data are displayed based on the
user’s activity.
 Error Handling: Proper error handling prevents the application from repeatedly executing failed
operations.
 Modular Code: Separate modules make the code easier to maintain, debug, and optimize.
 Avoiding Duplicate Data Processing: Data is processed only when required, reducing unnecessary
computation.
Overall, these optimization techniques help RoomieSync achieve better response time, efficient resource
utilization, maintainable code, and improved user experience.

5.3 Testing Approach
Testing Approach Testing is essential to en sure that RoomieSync functions correctly, meets all requirements,
and generates dependable outcomes. The system undergoes testing at multiple levels, beginning with
individual modules and advancing to the full application. The primary testing methodologies utilized are
Unit Testing, Integration Testing, and System Testing.
5.3.1 Unit Testing
Unit testing involves examining each module or function in isolation. Each module is assessed to verify its
expected performance. In RoomieSync, unit testing focuses on modules such as user registration, login,
profile management, compatibility score calculation, roommate requests, property management, meal
subscription, expense calculation, and agreement generation.
Examples: -
 Verifying that valid registration information successfully creates a user account.
 Ensuring that invalid login credentials are properly rejected. Confirming that the compatibility score is
calculated accurately.
 Determining if expenses are appropriately allocated among roommates.
 Verifying that property information is accurately stored.
5.3.2 Integration Testing
Integration testing occurs following the testing of individual units. It assesses whether various modules
operate correctly when integrated. In RoomieSync, integration testing evaluates the interactions between the
frontend, backend, database, and different application modules.
Examples: - User Login, User Profile, Dashboard Interface. - Roommate Matching, Request Submission,
Request Approval, Messaging. - Property Search Functionality, Property Reservation, Owner Dashboard. -
Roommate Matching, Creation of Agreements. - Expense Input, Database Interaction, Expense Overview. –
Meal Options, Subscription Service, Database Interaction.
5.3.3 System Testing
System testing evaluates the complete RoomieSync application as a unified system to ensure that all
modules work together as intended and meet the functional requirements. The entire user journey is tested,
starting from registration and profile completion to roommate matching, request acceptance, chatting,
property booking, meal subscription, agreement generation, expense management, and review submission.
Security features such as authentication and access restrictions are also tested to ensure the system is secure
and functions as expected.
Example:
 Signing up as a new user and completing profile details. Logging in and accessing the dashboard.
 Searching for and matching with suitable roommates.
 Sending and approving roommate requests.
 Accessing chat features only after a request has been accepted.
 Property owners uploading a listing with JPG/PNG images.
 Users reserving a property that is currently available.
 Creating a digital agreement for roommates. Handling shared costs.
 Transitioning between light mode and dark mode.

5.4 Modifications and Improvements
During the development of RoomieSync, s everal modifications and improvements were made to enhance the
functionality, usability, security, and overall performance of the system. The authentication module was
improved to provide secure user login and registration. A profile management module was added so that
users can enter and update their lifestyle preferences, which are used for roommate compatibility matching.
The property management module was enhanced with a separate panel for property owners, allowing them
to add property details and upload property images directly in JPG format. A chat module was incorporated
so that users can communicate after a roommate request is accepted. Meal subscription, agreement
generation, expense management, and review functionalities were also integrated to provide a complete
flatmate management system. A light and dark mode toggle was added to improve user interface
accessibility and personalization. These modifications helped make RoomieSync more convenient,
functional, and user-friendly.

CHAPTER 6: RESULTS AND DISCUSSION
6.1 User Documentation
User Manual with Screen Layouts
The RoomieSync user manual provides instructions for using the different features of the application. The
system is designed with a simple interface so that users can easily navigate between different modules.
6.1.1 Registration and Login
The user first registers by entering the required details such as name, email, password, and other necessary
information. After successful registration, the user can log in using their registered credentials.
Screen Layout:
6.1.2 User Profile
After successful login, the user is directed to the Profile page. The user can enter and update personal and
lifestyle preferences such as food preference, sleep schedule, smoking/drinking habits, occupation, and
interests.
Screen Layout:

6.1.3 Roommate Matching
The user can access the roommate matching module to find suitable roommates. The system compares the
lifestyle preferences of users and generates a compatibility score. Users can view suitable matches and send
roommate requests.
Screen Layout:
6.1.4 Property Search and Booking
Users can browse available properties and view details such as property name, location, rent, facilities,
availability, and uploaded images. Users can select a suitable property and proceed with the booking
process.
Screen Layout:

6.1.5 Property Owner Panel
Property owners can access a separate owner panel to add and manage their properties. The owner can enter
property details and upload property images in JPG format.
Screen Layout:

6.1.6 Meal Subscription
Users can view available meal plans and select a suitable plan. The user can enter the subscription period
and manage the status of their meal subscription.
Screen Layout:
6.1.7 Agreement Generation
After finalizing the property and user details, the agreement module allows the system to generate an
agreement containing the required terms and details.
Screen Layout:
6.1.8 Expense Management
Users can record and manage expenses related to their shared accommodation. Expenses can include the
amount, category, description, and date.
Screen Layout:

6.1.9 Reviews
Users can provide reviews and ratings for properties or other users after their interaction or stay. This helps
provide feedback and improves the reliability of the platform.
Screen Layout:
6.1.10 Light and Dark Mode
The application provides a light and dark mode toggle that allows users to change the appearance of the
interface according to their preference.
Screen Layout:

6.1.11 Logout
After completing their activities, users can select the Logout option to securely end their session and return
to the login screen.
Screen Layout:

CHAPTER 7: CONCLUSIONS
7.1 Conclusion
The RoomieSync project has been completed with the aim of providing a simple and efficient platform for
students and individuals to find suitable roommates and accommodation. The system allows users to create
profiles, specify their lifestyle preferences, find compatible roommates, send and accept roommate requests,
communicate through chat, search and book properties, subscribe to meal plans, generate agreements, and
manage shared expenses. The project provides an organized and user-friendly platform that simplifies the
overall process of finding a suitable roommate and managing shared living arrangements.
7.2 Limitations of the System
 The accuracy of roommate compatibility depends on the information and preferences provided by the
users.
 The availability and details of properties depend on the information added by property owners.
 Real-time chat functionality requires a stable internet connection.
 The system currently provides compatibility based on predefined user preferences and does not use AI-
based recommendations.
 Online payment and verification facilities may have limited functionality in the current version.
7.3 Future Scope of the Project
 The system can be enhanced by adding advanced filters for finding roommates and properties based on
location, budget, lifestyle, and other preferences.
 A notification system can be added to inform users about roommate requests, messages, bookings, and
upcoming payments.
 Online payment functionality can be integrated for property bookings and meal subscriptions.
 Property owners can be provided with an enhanced dashboard to manage properties, images, bookings,
and availability.
 The system can be extended with additional features such as user verification, complaint management,
and emergency contact facilities.
 The application can be developed as a mobile application to provide users with easier access to
RoomieSync.

REFERENCES
1. React Documentation, React – A JavaScript Library for Building User Interfaces. https://react.dev/
2. Node.js Documentation, Node.js Official Documentation. https://nodejs.org/docs/latest/api/
3. MongoDB Documentation, MongoDB Manual and Database Documentation. MongoDB Documentation
4. Mongoose Documentation, Mongoose ODM Documentation. Mongoose Documentation
5. Express.js Documentation, Express – Node.js Web Application Framework. https://expressjs.com/
6. Mozilla Developer Network (MDN), HTML, CSS and JavaScript Documentation. MDN Web Docs
7. MongoDB Documentation, Data Modelling and CRUD Operations. MongoDB Data Modelling
Documentation

GLOSSARY
Term Definition
A web-based platform designed to help users find compatible roommates and
RoomieSync
suitable accommodation.
A web development technology stack consisting of MongoDB, Express.js,
MERN Stack
React.js, and Node.js.
A JavaScript library used to develop the frontend and user interface of
React.js
RoomieSync.
Node.js A JavaScript runtime used to execute server-side code.
Express.js A Node.js framework used to develop the backend and REST APIs.
MongoDB A NoSQL document-oriented database used to store RoomieSync data.
Mongoose An ODM library used to interact with MongoDB from the Node.js backend.
The user-facing part of the application through which users interact with
Frontend
RoomieSync.
The server-side part of the system responsible for business logic, APIs,
Backend
authentication, and database operations.
Application Programming Interface that allows the frontend and backend to
API
communicate with each other.
JWT JSON Web Token used for secure user authentication and authorization.
Authentication The process of verifying the identity of a registered user.
The process of determining what actions or resources an authenticated user
Authorization
can access.
A collection of personal and lifestyle information maintained by a RoomieSync
User Profile
user.
User preferences such as budget, food habits, smoking, drinking, sleep
Lifestyle Preferences
schedule, interests, and occupation.
A percentage value representing how well two users match based on their
Compatibility Score
lifestyle and preference information.
The system component responsible for comparing user preferences and
Matching Engine
recommending suitable roommates.
The process of identifying users with similar or compatible lifestyles and
Roommate Matching
preferences.

Term Definition
Accommodation
Information about a room, flat, or PG made available by a property owner.
Listing
Property Owner A person who adds and manages accommodation listings on RoomieSync.
CRUD Create, Read, Update, and Delete operations performed on application data.
A database approach that stores data in flexible formats such as documents
NoSQL
instead of traditional relational tables.
A design approach that allows the website interface to adapt to different screen
Responsive Design
sizes and devices.
An API architecture used for communication between the frontend and
REST API
backend using HTTP requests.
Database An organized collection of data stored and managed by the application.