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
- **Story:** Sports players are able to connect with others and meet up to socialize and play the sport they love.
- **Market:** People who play any type of sport or would like to get into sports can benefit from Playmate.
- **Habit:** Playmate will be used when users wish to schedule a session to play a certain sport. Depending on how often a user wants to play, this app may be used on any type of basis, from daily to monthly.
- **Scope:** To start off, Playmate will focus on the creating and joining sports sessions feature as well as personalized user profiles. Expansion may include messaging and a feed to view friends' activity.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [ ] User can create account and log in
* [ ] User can customize their profile
* [ ] User can set their origin location on map
* [ ] User can see sessions on a calendar
* [ ] User can search for sessions based on filters they set
* [ ] User can add themself to an existing session after search
* [ ] User can create session if no existing ones match their liking
* [ ] User can search for sports facility in map view for create session feature
* [ ] User can add friends and view their profiles

**Optional Nice-to-have Stories**

* [ ] User will be notified of upcoming sessions in advance, according to their preference
* [ ] User can delete or remove themselves from sessions
* [ ] User can message their friends and session groups
* [ ] User can post to a feed about their past sessions
* [ ] User will be automatically reccommended sessions based on their past activity

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
* Messages

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
