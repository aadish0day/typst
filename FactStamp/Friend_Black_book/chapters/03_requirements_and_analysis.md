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

