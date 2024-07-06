# Design Document

By Bryan Johns

Video overview: <URL HERE>

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?

Build a database of AirBnB listings in Washington, DC, for use in a Jupyter notebook exploratory data analysis, a Tableau explanatory data analysis, and a web dashboard. It must be in PostgreSQL. It must contain the data necessary for a JavaScript map already made. I'm reverse-engineering this thing.

* Which people, places, things, etc. are you including in the scope of your database?

A plethora of information related to AirBnB listings, such as location, bed(/bath)rooms, amenities, pricing, host info, reviews, etc.

* Which people, places, things, etc. are *outside* the scope of your database?

This is a great question, but the reality is: anything not already in the data set. The maximum scope is pre-determined. But, I shall whittle away at the data collected and make note of it here, and set the minimum scope.

## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?

Query the stats of AirBnB's in Washington, DC. Find out how many are in which neighborhood, and what kind of rental ("Full home"? "Private Room"?). It's for data analysis.

* What's beyond the scope of what a user should be able to do with your database?

Book an actual AirBnB. 

Justify ignoring any data scrapped from the web here, like max/min nights.

## Representation

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?

Listings, hosts, neighborhoods, reviews, reviewers... pondering... I'll fill this in as I go along. A lot depends on the available data, and I'll decide what goes where afterwards. Make it lean. Keep only the essential data.

* What attributes will those entities have?



* Why did you choose the types you did?



* Why did you choose the constraints you did?



### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?

!!!!! Create a view for the JavaScript map, and an index for neighborhoods !!!!!!

?Create views for plotly plots?

Make efficient queries for the webpage's api calls.

I'm biased towards speed of query to load on the webpage. I will be the only one updating the database, and that infrequently, so the amount of time and complexity involved doesn't bother me. The amount of memory storage necessary is mostly inconsequential to me.

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?

It takes up more storage space, due to indexes for speed. I have to be the one to update it.

Not really designed for create, update, delete - only read. CRUD disappointed.

* What might your database not be able to represent very well?

