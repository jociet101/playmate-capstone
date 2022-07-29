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

* [ ] User can create account and log in
* [ ] User can customize their profile
* [ ] User can see own sessions on a calendar
* [ ] User can explore nearby sessions on a map
* [ ] User can search for sessions based on filters they set
* [ ] User can add themself to an existing session after search
* [ ] User can remove themself from a session
* [ ] User can create session if no existing ones match their liking
* [ ] User can search for location on map to set their session location
* [ ] User can send and approve or deny friend requests
* [ ] User can remove friend

**Optional Nice-to-have Stories**

* [ ] User can edit their profile
* [ ] User will be notified of upcoming sessions through iOS notifications
* [ ] User can open session location in Apple or Google maps
* [ ] User can invite friends to a session they are already in
* [ ] User can delete a session they created
* [ ] User can take preferences quiz to get better suggestions
* [ ] User will be suggested sessions based on an AI heuristic

### 2. Screen Archetypes

* [list first screen here]
   * [list associated required story here]
   * ...
* [list second screen here]
   * [list associated required story here]
   * ...

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

