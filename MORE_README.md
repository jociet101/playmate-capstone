#  Playmate README continued

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
Playmate's Recommendation algorithm uses filtering to narrow down the pool of all Playmate sessions to a smaller pool of sessions that only include the viable session options according to the user's preferences. 

Then, a heuristic equation is used to assign a "ranking" to each of the viable sessions and the top twenty are displayed as suggested sessions to the user.

### Answering questions you might have

1. This algorithm–filtering and ranking– seems pretty computation heavy. When do you decide to execute this algorithm to conserve resources but also keep a user's suggested sessions up to date?

- after fill out quiz
- every third/fifth (decide a number) session a user joins

2. repeat suggestions??


External Resources
- [Recommendation System Design in the Real World](https://medium.com/double-pointer/system-design-interview-recommendation-system-design-as-used-by-youtube-netflix-etc-c457aaec3ab)

