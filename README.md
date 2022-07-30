Playmate - App Design Capstone Project, MetaU 2022
===
**Intern**: Jocelyn Tseng

**Intern Manager**: Carmen Salvador

# Playmate

## Table of Contents
1. [Overview](#Overview)
3. [Product Spec](#Product-Spec)
4. [Wireframes](#Wireframes)
5. [Schema](#Schema)

## Overview
### Description
Playmate is a platform where sports players can conveniently find others to play with given a time and place.

### App Evaluation
- **Category:** Sports social networking
- **Mobile:** Playmate will be developed for iOS.
- **Story:** Sports players are able to connect with others on the app and then meet up in real life to socialize and play the sport they love.
- **Market:** People who play any type of sport or would like to get into sports can benefit from Playmate.
- **Habit:** Playmate will be used when users wish to schedule a session to play a certain sport. Depending on how often a user wants to play, this app may be used on any type of basis, from daily to monthly. 
- **Scope:** Playmate's focus is on creating sports sessions and filtering sessions to find suitable ones to join. Playmate also supports personalized user profiles, friending between users, and session invitations to and from friends.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User can create account and log in
* [x] User can customize their profile
* [x] User can view their own sessions in a carousel view on home tab
* [x] User can see own sessions on a calendar
* [x] User can explore nearby sessions on a map
* [x] User can search for sessions based on filters they set
* [x] User can join an existing session after search
* [x] User can remove themself from a session
* [x] User can create session if no existing ones match their liking
* [x] User can search for location on map to set their session location
* [x] User can send and approve or deny friend requests
* [x] User can remove friend

**Optional Nice-to-have Stories**

* [x] User can edit their profile
* [x] User will be notified of upcoming sessions through iOS notifications
* [x] User can open session location in Apple or Google maps
* [x] User can invite friends to a session they are already in
* [x] User can view and accept or deny invite
* [x] User can delete a session they created
* [x] User can view their Playmate and session statistics
* [x] User can take preferences quiz to get better suggestions
* [ ] User will be suggested sessions based on an AI heuristic
* [ ] App has polished UI
* [ ] User can report another user

### 2. Screen Archetypes

* Home Tab
   * View upcoming sessions in a carousel view
   * View suggested sessions in the same way
   * Take preferences quiz to get better suggestions
* Calendar
   * See own sessions on a calendar
* Explore Nearby
   * Explore nearby sessions on a map
* Session Details
   * Open session location in Apple or Google maps
   * Join a session
   * Leave a session
   * Delete a session they created
   * Invite friends to a session they are already in
* Search Tab
   * Search for existing sessions
   * Apply filters to search for desired session properties
   * Can search for location on map to set their session location
* Create Tab
   * Create session if no existing ones match their liking
* Profile Tab
   * Customize their profile
* Notifications
   * Approve or deny friend requests
   * View and accept or deny invite
* Player Profile
   * Send friend requests and remove friend
   * View their Playmate and session statistics

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Page
* Search
* Calendar
* Profile

**Flow Navigation** (Screen to Screen)

* Welcome Screen
   * If do not have account: Create Account
   * If have account: Login Screen
* Home
   * Calendar View
      * Session Details
   * Upcoming Sessions
* Search
   * Session Details
   * Filter Settings
   * Map View
* Create
   * To select location: Map View
* Profile
   * Past Sessions
   * Friends List
      * Friend's Profile
* Messages
   * Message Thread


## Wireframes

### Hand-drawn Wireframe

<img width="1139" alt="wireframe" src="https://user-images.githubusercontent.com/73032138/176614780-5b500535-2992-47ae-b191-0c4eb22b798e.png">

## Schema 

### Models

##### Session : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | sport           | String            | Which sport players in this session will play |
  | creator         | Pointer to PFObject(Profile) | Profile of user who created the session |
  | players         | Array(of pointers to PFUser ) | List of users who are participating in the session |
  | occursAt        | DateTime          | Date and time of when the session occurs |
  | location        | PFObject(Location)| Location where session occurs |
  | capacity        | Number            | Total number of people who can be part of the session |
  | occupied        | Number            | Current number of people who are part of the session |
  
#### Location : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | longitude       | Number            | Longitude of the location on a map |
  | latitude        | Number            | Latitude of the location on a map |
  | name            | String            | Name of the location |
  | city            | String            | City of the location |
  | country         | String            | Country of the location |
  
#### Profile : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | user            | Pointer to PFUser            | User attached to this profile |
  | profileImage    | Pointer to PFFileObject      | Profile image uploaded by user |
  | name            | String            | User's name |
  | birthday        | DateTime          | User's birthday |
  | gender          | String            | User's gender |
  | numFriends      | Number            | Number of friends user has |
  | friendsList     | Array(of PFUser)  | List of friends |
  
#### Message : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | sender          | Pointer to PFUser            | User the message is being sent form |
  | recipient       | Pointer to PFUser            | User the message is being sent to |
  | text            | String            | Text of the message |
  | createdAt       | DateTime          | Time the message was sent |
  

### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]


### External resources

- Empty Table View UI [https://github.com/dzenbot/DZNEmptyDataSet]
- Geocoding API [https://www.geoapify.com/places-api]
- Decathalon API [https://developers.decathlon.com/products/sports]

### Demo from 7/12/22



https://user-images.githubusercontent.com/73032138/178580985-f6e8705c-0ef0-4869-bef2-35446362310f.mov

