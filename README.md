Playmate - App Design Capstone Project, MetaU 2022
===
**Intern**: Jocelyn Tseng

**Intern Manager**: Carmen Salvador

[https://courses.codepath.com/courses/metau_ios/unit/2#!capstone_1]

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
[Evaluation of your app across the following attributes]
- **Category:** Sports social networking
- **Mobile:** Playmate will be developed for iOS.
- **Story:** Sports players are able to connect with others and meet up to socialize and play the sport they love.
- **Market:** People who play any type of sport or would like to get into sports can benefit from Playmate.
- **Habit:** Playmate will be used when users wish to schedule a session to play a certain sport. Depending on how often a user wants to play, this app may be used on any type of basis, from daily to monthly.
- **Scope:** To start off, Playmate will focus on the creating and joining sports sessions feature as well as personalized user profiles. Expansion may include messaging and a feed to view friends' activity.

## Product Spec

**Uncategorized Brainstorming**
* Home tab: Upcoming sessions, friends activity
* Search for sessions tab (need a better name): user must input information in calendar and map tabs first (maybe have segues to them and bring them back once done), have filters for what type of sports session user is looking for: 
* Calendar tab: Time blocks in different colors; times the user is open, times the user has booked sessions, etc.
* Map tab: Places user is willing to travel to to meet up, pin on a location and have a specified radius
    * google maps?
    * apple maps api
* Profile page: Profile image, male/female sports user plays, bio, (add other profile elements and for sign up), friends, friend requests
* (STRETCH) Messaging page: users can message others to chat about upcoming session or other sports stuff

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [ ] User can create account and log in
* [ ] User can customize their profile
* [ ] User can edit location on map
* [ ] User can see sessions on a calendar
* [ ] User can search for sessions based on filters they set
* [ ] User can add themself to an existing session after search
* [ ] User can create session if no existing ones match their liking
* [ ] User can add friends and view their profile

**Optional Nice-to-have Stories**

* [ ] User will be notified of upcoming sessions in advance, according to their preference
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
   * Map View
   * Calendar View
      * Session Details
   * Upcoming Sessions
* Search
   * Session Details
   * Filter Settings
* Create
* Profile
   * Past Sessions
   * Friends List
      * Friend's Profile
* Messages
   * Message Thread


## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="YOUR_WIREFRAME_IMAGE_URL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
