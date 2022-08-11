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
6. [Walkthroughs](#Walkthroughs)
7. [Playmate's Recommendation System](#Recommendation-System)
8. [External Resources](#External-Resources)

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

### Networking
- Network requests by screen
    * Welcome Screen
        * If do not have account: Create Account
            * (Create/POST) Create a user profile
        * If have account: Login Screen
            * (Read/GET) Query logged in user account
    * Home
        * Notifications View
            * (Read/GET) Query Incoming FriendRequests objects, Outgoing Requests, and Invitations objects
        * Take Quiz Views (Composed of five view controllers)
            * (Create/POST) Create QuizResult object if is user's first time taking quiz
            * (Update/PUT) Update QuizResult if user has existing result
        * Explore Nearby
            * (Read/GET) Query SportsSessions to display on map and according to filters
        * My schedule
            * Each Day
                * (Read/GET) Query SportsSessions that logged in user is part of on a certain day
        * Upcoming Sessions
            * (Read/GET) Query this user's upcoming SportsSessions
        * Suggested Sessions
            * (Read/GET) Query this user's RecommendationData object and get suggested sesions list
    * Session Details
        * (Read/GET) Query SportsSession class object to display
    * Search
        * (Read/GET) Query all SportsSessions in the entire database
        * Filter Settings
            * Query SportsSessions according to filters
    * Create
        * (Create/POST) Create new SportsSession object
    * Profile
        * Friends List
            * (Read/GET) Query friends list from this user's profile
            * Player Profile View
                * (Read/GET) Query PFUser corresponding to this profile
        * Notifications View
            * (Read/GET) Query Incoming FriendRequests objects, Outgoing Requests, and Invitations objects
        * Edit Profile
            * (Update/PUT) Add to user's profile object if changes are made
        
- GeoAPIfy Network Requests (Endpoint: https://api.geoapify.com/v1/)
    - Geocoding
        ```objective-c
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
                completion(nil, error);
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                // parse dictionary
                NSArray *results = dataDictionary[@"results"];
                
                if (results.count == 0) {
                    completion(nil, nil);
                }
                else {
                    NSDictionary *firstResult = results[0];
                    
                    Location *loc = [Location new];
                    loc.lat = [NSNumber numberWithDouble:[firstResult[@"lat"] doubleValue]];
                    loc.lng = [NSNumber numberWithDouble:[firstResult[@"lon"] doubleValue]];
                    loc.locationName = firstResult[@"formatted"];
                    
                    completion(loc, nil);
                }
            }
        }];
        ```
    - Reverse Geocoding
        ```objective-c
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                // handle alert if need be
                [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
                completion(nil, error);
            }
            else {
                // retrieve data
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                // parse dictionary
                NSDictionary *result = dataDictionary[@"features"][0][@"properties"];
                completion(result[@"formatted"], nil);
            }
        }];
        ```


## Walkthroughs

* Create Account and Login (Password does not appear on screen recording)


https://user-images.githubusercontent.com/73032138/184195430-b5a45e88-efce-4f28-a367-ee74bd8c98de.MP4


* Home Tab and Session Details

* 

## Recommendation System

### Goal
The goal of Playmate's Recommendation System is to suggest sessions to users based on their preferences and session histories. Each user will be suggested sessions that are catered towards their unique taste and according to our algorithm, are the sessions they would most likely want to join if they were to search themselves.

### What it needs
Like any AI algorithm, Playmate's Recommendation System requires user data such as preferred sports, gender, age groups, location, etc. to suggest the most optimal sessions. This data will be acquired through what the user has already supplied to us by joining sessions and voluntarily taking the preferences quiz.

### How it works
Playmate's Recommendation algorithm uses filtering to narrow down the pool of all Playmate sessions to a smaller pool of sessions that only include the viable session options according to the user's preferences. Specifically, the algorithm first filters by location, only allowing the sessions that are within a certain radius of the user's origin location, and then by filtering out session of sports that the user told us they would not like to play through the quiz. Location and sport are broad categories that allow us to produce the smallest but still accurate pool of viable sessions.

Once the general filters are applied, a heuristic equation is used to assign a "ranking" to each of the viable sessions. The heuristic takes into account the quiz results, whether the user is friends with anyone in the session, and which sport and skill level sessions the user has participated in the past. The quiz results include what sports the user plays, what sports the user does not want to play, and what genders and age groups the user prefers to play sports with.

After preprocessing and calculating certain statistics for each session, the heuristic equation:

`float ranking = 5.2 * sportWeight + 2.3 * numberFriendsInSession + 1.2 * numberPlayersInPreferredGenders + 1.9 * numberPlayersInPreferredAgeGroups`

is used to assign a value to each session. Upon assigning a value to each of the viable session options, session are sorted and the most highly ranked sessions are displayed as suggested sessions to the user.

### FAQs

1. This algorithm, which includes filtering and ranking, seems pretty computation heavy. When do you decide to execute this algorithm to conserve resources but also keep a user's suggested sessions up to date?

- The recommendation system algorithm I designed is run every time after a user fills out the quiz to ensure their latest preferences are responded to as soon as possible.

- Since the total number of sessions is not yet in the thousands, we can afford to run the algorithm every third session a user joins. However, as the app scales, we would reduce the number of times the algorithm is run to conserve resources.

- The entire algorithm is run on a Grand Central Dispatch queue on a separate thread, so it would not interfere with processes on the main thread managing front end and other imminent tasks.


2. What expansions and improvements do you have in mind for Playmate's Recommender System?

- The user responds to each suggestion with a yes or no for whether they would attend the session and if not, the reason they would not attend the session. The algorithm would then take into account the reason and give a lower weight to sessions that share the similar trait. For example, if we suggest a session of the sport "Soccer" that is neither on the user's past history nor in their quiz preferences, and they tell us they would not attend the session because of the sport, we will adapt and remember to not suggest any Soccer sessions to this user.

- Running the recommender system algorithm on a separate server would improve the quality of suggestions because they would be more up to date and dynamically adapt to what sessions the user is joining or creating. Also, we would be able to run the algorithm asynchonously as new sessions are created by other users, and suggest those to our users. Being able to run the algorithm on a backend server would also be useful as the number of users scale and therefore sessions increase.

## External resources

- CocoaPods
    - [Parse](https://github.com/parse-community/Parse-SDK-iOS-OSX)
    - [AFNetworking](https://github.com/AFNetworking/AFNetworking)
    - [DateTools](https://github.com/MatthewYork/DateTools)
    - [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)
    - [FSCalendar](https://github.com/WenchaoD/FSCalendar)
    - [TTGTagCollectionView](https://github.com/zekunyan/TTGTagCollectionView)
    - [CCTextFieldEffects](https://github.com/Cokile/CCTextFieldEffects)
    - [JGProgressHUD](https://github.com/JonasGessner/JGProgressHUD)
- APIs
    - [Geocoding API](https://www.geoapify.com/places-api)
    - [Decathalon API](https://developers.decathlon.com/products/sports)
- Websites
    - [Apple Maps](https://www.apple.com/maps/)
    - [Google Maps](https://www.google.com/maps)
- Sport Logos
    - [Tokyo Olympics Pictograms](https://www.theolympicdesign.com/olympic-design/pictograms/tokyo-2020/)
    - [Image Background Removal](https://picwish.com/upload)
- Research
    - [Recommendation System Design in the Real World](https://medium.com/double-pointer/system-design-interview-recommendation-system-design-as-used-by-youtube-netflix-etc-c457aaec3ab)
