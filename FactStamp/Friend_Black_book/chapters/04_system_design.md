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

