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
6. [Demos](#Walkthroughs-and-Demos)

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
* [x] User will be suggested sessions based on an AI heuristic
    * Description of Playamte's recommendation system is in MORE\_README.md

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
   * Notifications View
   * Take Quiz Views (Composed of five view controllers)
   * Explore Nearby
      * Map Filters View
         * Select Location View
   * My schedule
      * Session Details
   * Upcoming Sessions
      * Session Details
   * Suggested Sessions
      * Session Details
* Search
   * Session Details
   * Filter Settings
      * Select Location View
* Create
   * Select Location View
      * How to Select Location View
* Profile
   * Friends List
      * Player Profile View (Continues -> Friend List -> Player Profile -> ...)
   * Notifications View
      * Incoming Friend Requests
      * Outgoing Friend Requests
      * Invitations
   * Edit Profile


## Wireframes

### Initial Hand-drawn Wireframe

<img width="1139" alt="wireframe" src="https://user-images.githubusercontent.com/73032138/176614780-5b500535-2992-47ae-b191-0c4eb22b798e.png">

## Schema 

### Models

#### SportsSession : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | sport           | String            | Which sport players in this session will play |
  | skillLevel      | String            | Skill level assigned to the session |
  | creator         | Pointer to PFUser | Profile of user who created the session |
  | playersList     | Array(of pointers to PFUser ) | List of users who are participating in the session |
  | occursAt        | DateTime          | Date and time of when the session occurs |
  | duration        | Number            | Length of the session in hours and minutes |
  | location        | Pointer to PFObject(Location)| Location where session occurs |
  | capacity        | Number            | Total number of people who can be part of the session |
  | occupied        | Number            | Current number of people who are part of the session |
  
#### Location : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | longitude       | Number            | Longitude of the location on a map |
  | latitude        | Number            | Latitude of the location on a map |
  | locationName    | String            | Name of the location |
  
#### PlayerConnection : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | userObjectId    | String            | objectId of the user this belongs to |
  | friendsList     | Array             | List of user objectId's of this person's friends |
  | pendingList     | Array             | List of user objectId's of people whom this user has sent friend request to and other user has not replied |
  
#### QuizResult : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | userObjectId    | String            | objectId of the user this belongs to |
  | playSportsList  | Array             | List of the sports this user said they play |
  | dontPlaySportsList | Array          | List of sports this user said they do not want to play |
  | gendersList     | Array             | List of preferred Playmate gender of this user |
  | ageGroupsList   | Array             | List of preferred Playmate age groups of this user |
  
#### Invitation : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | invitationToId  | String            | objectId of the user this invitation is to |
  | invitationFromId | String           | objectId of the user this invitation is from |
  | sessionObjectId  | String           | objectId of the session this invitation is for |

#### User : PFUser : PFObject
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | username(+)     | String            | User's username |
  | password(+)     | String            | User's password |
  | email(+)        | String            | User's email |
  | profileImage    | Pointer to PFFileObject      | Profile image uploaded by user |
  | firstName       | String            | User's first name |
  | lastName        | String            | User's last name |
  | birthday        | DateTime          | User's birthday |
  | gender          | String            | User's gender |
  | numFriends      | Number            | Number of friends user has |
  | friendsList     | Array(of PFUser)  | List of friends |
  | biography(-)    | String            | User's biography |
  | sessionsDictionary(-) | Dictionary  | User's session history where key is sport and value is array of session objectId's for that sport |
  | playerConnection(-) | String        | objectId of user's player connection object that stores friend data |
  | quizResult      | String            | objectId of user's quiz result object that holds quiz data after they take it |
  
+:(default PFUser property)  
-:(optional, nil by default)

### Networking (TODO)
- Network requests by screen
- Basic snippets for each Parse network request
- API Endpoints

### External resources

- CocoaPods
    - [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX)
    - [AFNetworking](https://github.com/AFNetworking/AFNetworking)
    - [DateTools](https://github.com/MatthewYork/DateTools)
    - [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)
    - [FSCalendar](https://github.com/WenchaoD/FSCalendar)
    - [TTGTagCollectionView](https://github.com/zekunyan/TTGTagCollectionView)
    - [CCTextFieldEffects](https://github.com/Cokile/CCTextFieldEffects)
- APIs
    - [Geocoding API](https://www.geoapify.com/places-api)
    - [Decathalon API](https://developers.decathlon.com/products/sports)
- Websites
    - [Apple Maps](https://www.apple.com/maps/)
    - [Google Maps](https://www.google.com/maps)
- Sport Logos
    - [Tokyo Olympics Pictograms](https://www.theolympicdesign.com/olympic-design/pictograms/tokyo-2020/)
    - [Image Background Removal](https://picwish.com/upload)

### Walkthroughs and Demos

