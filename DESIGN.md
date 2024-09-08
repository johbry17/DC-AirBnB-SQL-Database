# Design Document

By Bryan Johns

Video overview: <URL HERE>

GitHub repo here: [https://github.com/johbry17/DC-AirBnB-SQL-Database](https://github.com/johbry17/DC-AirBnB-SQL-Database).

It's designed to support the project located in this repo here: [https://github.com/johbry17/DC-AirBnB-Data](https://github.com/johbry17/DC-AirBnB-Data).

## Scope

In this section you should answer the following questions:

* What is the purpose of your database?

Data analysis. The database is for managing and analyzing data on AirBnB listings in Washington, DC. It supports both exploratory and explanatory data analysis and is designed for use in a Jupyter Notebook, Tableau, and a web dashboard. I built it in PostgreSQL. It contains the data necessary for a JavaScript map in the web dashboard. It supports functionalities like viewing the individual listings on a map, understanding host behavior, and analyzing reviews, availability, and pricing. As such, it will be read-only for the general user, with myself committing any updates.

* Which people, places, things, etc. are you including in the scope of your database?

**Listings** - Individual AirBnB listings and their details, like price, location, amenities. This data has been partitioned into multiple tables, with common numerical and categorical data in two primary tables, and several side tables tracking the future availability of the listings, info on minimum and maximum number of nights and price, and average review scores for different aspects of each listing.

**Hosts** - Hosts of AirBnB listings and their associated data, like response and acceptance rate, and methods of verifying host identity. Partitioned out is a separate host table covering the amount and type of listings the host offers, for analyzing hosts with multiple listings.

**Neighbourhood** - A list of various DC neighbourhoods, which links to the listings. Apparently, I'm going with the British spelling of neighbourhood.

**Reviews** - Info about each review of all listings.

**Calendar** - Records the price, availability and other details from the listing's calendar for each day of the next 365 days.

* Which people, places, things, etc. are *outside* the scope of your database?

AirBnB users who are not hosts, which I assume are guests - vacationers, business travelers, etc. I lack any detailed information about guests beyond reviews and reviewer names. This also includes AirBnB administrators / employees, and people who may have profiles but don't rent out spaces, like property maintenance staff and cleaners.

Listings outside of Washington, DC. This has a local focus on one city, and cannot contribute to a larger analysis of AirBnB on a country or global basis.

No information about transactions or bookings. Methods of payment, cancellations or refunds, timing of bookings, etc.

I know nothing about neighbourhood features (well, the database doesn't - I live in DC), which could impact the price and popularity of listings.

## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?

Viewing listings on a map with detailed information (e.g., price, property type, host info).

Use the web dashboard to see stats on AirBnB's in DC and at the neighbourhood level.

View exploratory and explanatory data analyses in Jupyter and Tableau.

Conduct their own analysis on listings and their attributes.

Access review and availability statistics.

Basically, data analysis on hosts and listings.

* What's beyond the scope of what a user should be able to do with your database?

Book an actual AirBnB. In fact, there is no real-time info. The database is a snapshot in time, last scraped in June of 2024.

No information of transaction history. I don't know who rented what, when.

No user-specific features. It can't be customized depending upon a user's preferences.

It only contains data for Washington, DC. It could easily be retooled for expansion to other cities in the future.

## Representation

### Entities

In this section you should answer the following questions:

* Which entities will you choose to represent in your database?

`hosts`, `host_listings_count`, `neighbourhoods`, `listings`, `listings_categorical`, `availability`, `min_max_night`, `listing_reviews`, `reviews`, `calendar`

This will contain all of the available data that I could get, although not all of it have I used yet in data analysis. It's there if I need it.

* What attributes will those entities have?

`hosts`

    "host_id" - Primary Key. AirBnB's unique identifier for the host/user
    "host_url" - The AirBnB page for the host
    "host_name" - Name of the host. Usually just the first name(s)
    "host_since" - The date the host/user was created. For hosts that are AirBnB guests this could be the date they registered as a guest
    "host_location" - The host's self-reported location
    "host_about" - Description about the host
    "host_response_time" - Host's response time to guest inquiries
    "host_response_rate" - Host's response rate to guest inquiries
    "host_acceptance_rate" - That rate at which a host accepts booking requests
    "host_is_superhost" - Boolean
    "host_thumbnail_url" - 
    "host_picture_url" - 
    "host_neighbourhood" - Presumably self-reported
    "host_listings_count" - The number of listings the host has (per AirBnB unknown calculations)
    "host_total_listings_count" - The number of listings the host has (per AirBnB unknown calculations)
    "host_verifications" - Phone, email, work email
    "host_has_profile_pic" - Boolean
    "host_identity_verified" - Boolean

`host_listings_count`

    "host_id" - Primary Key, Foreign Key to `hosts`
    "host_listings_total_count" - The number of listings the host has in the current scrape, in DC
    "host_listings_entire_homes_count" - The number of Entire home/apt listings the host has in the current scrape, in DC
    "host_listings_private_rooms_count" - The number of Private room listings the host has in the current scrape, in DC
    "host_listings_shared_rooms_count" - The number of Shared room listings the host has in the current scrape, in DC

`neighbourhoods`

    "neighbourhood_id" - Primary Key
    "neighbourhood" - The neighbourhood group as geocoded using the latitude and longitude against neighbourhoods as defined by open or public digital shapefiles

`listings`

    "listing_id" - Primary Key. AirBnB's unique identifier for the listing
    "host_id" - Foreign Key to `hosts`
    "neighbourhood_id" - Foreign Key to `neighbourhoods`
    "latitude" - Uses the World Geodetic System (WGS84) projection for latitude and longitude
    "longitude" - Uses the World Geodetic System (WGS84) projection for latitude and longitude
    "accommodates" - The maximum capacity of the listing
    "bathrooms" - The number of bathrooms in the listing, for older scrapes. On the AirBnB web-site, the bathrooms field has evolved from a number to a textual description
    "bedrooms" - The number of bedrooms
    "beds" - The number of bed(s)
    "price" - Daily price in local currency

`listings_categorical`

    "listing_id" - Primary Key, Foreign Key to `listings`
    "listing_name" - Name of the listing
    "hover_description" - Alternate of name, for map display
    "description" - Detailed description of the listing
    "listing_url" - 
    "neighborhood_overview" - Host's description of the neighbourhood
    "picture_url" - URL to the AirBnB hosted regular sized image for the listing
    "property_type" - Self selected property type. Hotels and Bed and Breakfasts are described as such by their hosts in this field
    "room_type" - All homes are grouped into the following room types: Entire home/apt, Private room, Shared room, Hotel room
    "amenities" - List of amenities
    "bathrooms_text" - The number of bathrooms in the listing. On the AirBnB web-site, the bathrooms field has evolved from a number to a textual description. For older scrapes, listings.bathrooms is used.
    "license" - The license/permit/registration number

`availability`

    "listing_id" - Primary Key, Foreign Key to `listings`
    "has_availability" - Boolean
    "availability_30" - The availability of the listing 30 days in the future as determined by the calendar. Note a listing may not be available because it has been booked by a guest or blocked by the host
    "availability_60" - The availability of the listing 60 days in the future as determined by the calendar. Note a listing may not be available because it has been booked by a guest or blocked by the host
    "availability_90" - The availability of the listing 90 days in the future as determined by the calendar. Note a listing may not be available because it has been booked by a guest or blocked by the host
    "availability_365" - The availability of the listing 365 days in the future as determined by the calendar. Note a listing may not be available because it has been booked by a guest or blocked by the host
    "calendar_last_scraped" - Scrape date
    "instant_bookable" - Boolean. Whether the guest can automatically book the listing without the host requiring to accept their booking request. An indicator of a commercial listing

`min_max_night`

    "listing_id" - Primary Key, Foreign Key to `listings`
    "minimum_nights" - Minimum number of night stay for the listing (calendar rules may be different)
    "maximum_nights" - Maximum number of night stay for the listing (calendar rules may be different)
    "minimum_minimum_nights" - The smallest minimum_night value from the calendar (looking 365 nights in the future)
    "maximum_minimum_nights" - The largest minimum_night value from the calendar (looking 365 nights in the future)
    "minimum_maximum_nights" - The smallest maximum_night value from the calendar (looking 365 nights in the future)
    "maximum_maximum_nights" - The largest maximum_night value from the calendar (looking 365 nights in the future)
    "minimum_nights_avg_ntm" - The average minimum_night value from the calendar (looking 365 nights in the future)
    "maximum_nights_avg_ntm" - The average maximum_night value from the calendar (looking 365 nights in the future)

`listing_reviews`

    "listing_id" - Primary Key, Foreign Key to `listings`
    "number_of_reviews" - The number of reviews the listing has
    "number_of_reviews_ltm" - The number of reviews the listing has (in the last 12 months)
    "number_of_reviews_l30d" - The number of reviews the listing has (in the last 30 days)
    "first_review" - The date of the first/oldest review
    "last_review" - The date of the last/newest review
    "review_scores_rating" - Rating score
    "review_scores_accuracy" - Listing accuracy score
    "review_scores_cleanliness" - cleanliness score
    "review_scores_checkin" - Score of check-in process
    "review_scores_communication" - Score of host's communication
    "review_scores_location" - Location score
    "reviews_per_month" - The average number of reviews per month the listing has over the lifetime of the listing
    "review_scores_value" - Value for price score

`reviews`

	"review_id" - Primary Key
    "listing_id" - Foreign Key to `listings`
    "review_date" - Date of review
    "reviewer_id" - Reviewer's AirBnB id
    "reviewer_name" - Reviewer's name
    "review_comments" - Actual review

`calendar`

    "id" - Primary Key
    "listing_id" - Foreign Key to `listings`
    "date" - The date in the listing's calendar
    "available" - Boolean. Whether the date is available for a booking
    "price" - The price listed for the day
    "minimum_nights" - Minimum nights for a booking made on this day
    "maximum_nights" - Maximum nights for a booking made on this day

* Why did you choose the types you did?

Data types were chosen to accurately represent each attribute, like FLOAT for `price` and `latitude`/`longitude`, or BOOLEAN for binary attributes, like `availability` and `host_identity_verified`. I used TEXT for strings, so it can be of variable length to conserve hard disk storage. I used BIGINT, as many of the numbers were large and needed extra hard disk space.

* Why did you choose the constraints you did?

Primary Keys to ensure uniqueness of each entity. Also because they are essential for each table.

Foreign keys to establish relationships between the entities.

The only other constraint I used was `NOT NULL`, to ensure some required fields were filled, like `price`. The Primary Keys ensure uniqueness enough for each entity. The only default value I had to set was created in Python (for price, based on the neighbourhood median). Check constraints were unnecessary.

### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

![Entity Relationship Diagram](./ERD.png)

Hosts to Listings - One-to-Many (`host_id`)

Hosts to Host_Listings_Count - One-to-One (`host_id`)

Neighbourhoods to Listings - One-to-Many (`neighbourhood_id`)

Listings to Listings_Categorical - One-to-One (`listing_id`)

Listings to Availability - One-to-One (`listing_id`)

Listings to Min_Max_Night - One-to-One (`listing_id`)

Listings to Listing_Reviews - One-to-One (`listing_id`)

Listings to Reviews - One-to-Many (`listing_id`)

Listings to Calendar - One-to-Many (`listing_id`)

## Optimizations

In this section you should answer the following questions:

* Which optimizations (e.g., indexes, views) did you create? Why?

In the acronym of CRUD, I am functionally only interested in the 'R'. I'm biased towards speed of query results, as the data is being used to load a webpage. I will infrequently update the database myself (quarterly), so the amount of time and complexity involved in updating doesn't bother me. I will keep a modest eye on the amount of hard disk memory storage taken up, but even that is mostly inconsequential to me.

I partitioned off a lot of the listings data into separate categories to speed runtime. I created two tables for common numerical and categorical data, and then several other tables for less frequently accessed data (availability, minimum and maximum night, aggregate review statistics).

The view `map_listings` created in the schema contains all of the fields necessary to populate a JavaScript map of the AirBnB's in DC, and also displaying some basic information at the neighbourhood level. This view returns data in 110-150 msec, versus ~500 msec for my original version of the query, cutting query time by at least a third. Combining relevant information from multiple tables into one view allows me simplify my map query into one API call: 'SELECT * FROM map_listings'.

To optimize joins, I built `idx_host_id` and `idx_neighbourhood_id` on the listings table. These are the only columns used in making joins that aren't already primary keys, so it should speed queries involving those joins. This does lead to increased storage space and longer insert / update times, but the trade-off is acceptable. I'm only going to update the data four times a year, and an extra 50MB is no big deal these days, compared to the scale of Big Data available.

Using an index for purposes other than speeding joins, I built the `idx_lat_long` to optimize load time of the map, which has a marker for every listing.

For any data used in the web dashboard plots, I created efficient queries to speed the loading of data.

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?

No optimizations to handle a high concurrency, a large volume of simultaneous users.

It takes up slightly more storage space, due to indexes, and a lot more storage space due to the inclusion of specific reviews and calendar data (review comments and the calendar table tripled the size of hard disk storage, from 100MB to 300MB). 

One big flaw is that it has to be updated manually. Much of that process has been automated, but I still have to start it. I intend to explore the feasibility of automating even that step, although I am a little nervous about scraping data without supervising it.

It's not really designed for the user to create, update, and delete - only read, disappointing the CRUD acronym.

It's entirely static. Not dynamic. No real-time updates. It assumes listings and hosts do not change. It will only ever provide a snapshot, based upon the day the website was scraped.

* What might your database not be able to represent very well?

Nothing real-time, like responding to changes in bookings.

No information on guests, those who rent AirBnB's.
