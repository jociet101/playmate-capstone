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

(TODO: describe the heuristic i designed and the equations, etc.)

Upon assigning a value to each of the viable session options, the most highly ranked sessions are displayed as suggested sessions to the user.

### FAQs

1. This algorithm, which includes filtering and ranking, seems pretty computation heavy. When do you decide to execute this algorithm to conserve resources but also keep a user's suggested sessions up to date?

- after fill out quiz (under average case assumption that the user does not fill out the quiz a bunch of times in a row)
- every third/fifth (decide a number) session a user joins
- use grand central dispatch to do in separate thread

2. how to prevent repeated suggestions? if that is a problem


3. How can Playmate's recommender system be improved?

- user responds to each suggestion with yes or no for whether they would attend and the reason they would or would not attend it (reason = sport, skill level, location, etc)
- dynamic adaptation, being able to refresh suggestions and get new ones --> much easier if there was more data, more sessions in the large pool to suggest


External Resources
- [Recommendation System Design in the Real World](https://medium.com/double-pointer/system-design-interview-recommendation-system-design-as-used-by-youtube-netflix-etc-c457aaec3ab)

