#  Playmate Walkthroughs and More about the Recommendation System

## Table of Contents
1. [Feature Walkthroughs](#Feature-Walkthroughs)
2. [Playmate's Recommendation System](#Recommendation-System)

## Feature Walkthroughs

hohoho

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

External Resources
- [Recommendation System Design in the Real World](https://medium.com/double-pointer/system-design-interview-recommendation-system-design-as-used-by-youtube-netflix-etc-c457aaec3ab)

