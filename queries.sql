-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

SELECT price 
FROM listings;
-- I'll be doing a lot of queries on price

SELECT 
    neighbourhood, 
    ROUND(AVG(price), 2) AS avg_price, 
    percentile_cont(0.5) WITHIN GROUP (ORDER BY price) AS median_price, 
    COUNT(*) AS number_of_listings
FROM listings
JOIN neighbourhoods ON listings.neighbourhood_id = neighbourhoods.neighbourhood_id
GROUP BY neighbourhood
ORDER BY avg_price DESC;
-- average and median prices, number of listings, by neighbourhood
-- lots of variants on this query - a lot of analysis on neighbourhood level

SELECT COUNT(*) FROM listings;
-- 4928 (number of listings)

SELECT AVG(price) FROM listings;
-- 186.45

SELECT AVG(accommodates) FROM listings;
-- 3.57

SELECT COUNT(*) FROM reviews;
-- 351089

SELECT AVG(review_scores_rating) FROM listing_reviews;
-- 4.77

SELECT AVG(number_of_reviews) FROM listing_reviews;
-- 71.26

SELECT AVG(number_of_reviews_ltm) FROM listing_reviews;
-- 17.98 (last twelve months)

SELECT AVG(number_of_reviews_l30d) FROM listing_reviews;
-- 1.57 (last 30 days)

SELECT MIN(price) FROM listings;
-- 22.0

SELECT MAX(price) FROM listings;
--10005.0

SELECT AVG(host_listings_count) FROM hosts;
-- 9.98
-- Note the discrepancy between these two
SELECT AVG(host_total_listings_count) FROM hosts;
-- 20.84
-- The above two queries are based on unknown AirBnB calculations
-- Wild specualtion: calculations based on all-time listings vs. current listings
-- The below query is based on current listings
SELECT AVG(listings_per_host)
FROM (
    SELECT COUNT(*) AS listings_per_host
    FROM listings
    GROUP BY host_id
) subquery;
-- 1.93

SELECT MAX(listings_per_host)
FROM (
    SELECT COUNT(*) AS listings_per_host
    FROM listings
    GROUP BY host_id
) subquery;
-- 199

SELECT COUNT(*) 
FROM ( 
	SELECT COUNT(*) AS listings_per_host 
	FROM listings 
	GROUP BY host_id 
	HAVING COUNT(*) = 1
) subquery;
-- 1946 (hosts with only one listing, 39.49% of the 4928 total)

SELECT * FROM listings
JOIN neighbourhoods ON listings.neighbourhood_id = neighbourhoods.neighbourhood_id
WHERE neighbourhoods.neighbourhood = 'Woodland/Fort Stanton, Garfield Heights, Knox Hill'
ORDER BY price;
-- because that neighbourhood oddly had a higher median than average price
-- the only one of the 39 neighbourhoods to do so
-- unsurprisingly low sample size (number of listings) (10)

SELECT room_type, COUNT(*) FROM listings_categorical GROUP BY room_type;
-- broad categories of room types
-- "Entire home/apt"	3798
-- "Shared room"	48
-- "Private room"	1069
-- "Hotel room"	13

SELECT property_type, COUNT(*) FROM listings_categorical GROUP BY property_type;
-- finer grained categories of property types






-- I actually loaded the data from pandas dataframes using sqlalchemy...
-- ...but this is how it could be inserted from csv files using the COPY command
-- substitute for INSERT INTO... commands

-- COPY command for the hosts table
COPY "hosts" (
    "host_id", 
    "host_url", 
    "host_name", 
    "host_since", 
    "host_location", 
    "host_about", 
    "host_response_time", 
    "host_response_rate", 
    "host_acceptance_rate", 
    "host_is_superhost", 
    "host_thumbnail_url", 
    "host_picture_url", 
    "host_neighbourhood", 
    "host_listings_count", 
    "host_total_listings_count", 
    "host_verifications", 
    "host_has_profile_pic", 
    "host_identity_verified"
) FROM './data/v2.0/hosts_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the host_listings_count table
COPY "host_listings_count" (
    "host_id", 
    "host_listings_total_count", 
    "host_listings_entire_homes_count", 
    "host_listings_private_rooms_count", 
    "host_listings_shared_rooms_count"
) FROM './data/v2.0/host_listings_count_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the neighbourhoods table
COPY "neighbourhoods" (
    "neighbourhood_id", 
    "neighbourhood"
) FROM './data/v2.0/neighbourhoods_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the listings table
COPY "listings" (
    "listing_id", 
    "host_id", 
    "neighbourhood_id", 
    "latitude", 
    "longitude", 
    "accommodates", 
    "bathrooms", 
    "bedrooms", 
    "beds", 
    "price"
) FROM './data/v2.0/listings_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the listings_categorical table
COPY "listings_categorical" (
    "listing_id", 
    "listing_name", 
    "hover_description", 
    "description", 
    "listing_url", 
    "neighborhood_overview", 
    "picture_url", 
    "property_type", 
    "room_type", 
    "amenities", 
    "bathrooms_text", 
    "license"
) FROM './data/v2.0/listings_categorical_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the availability table
COPY "availability" (
    "listing_id", 
    "has_availability", 
    "availability_30", 
    "availability_60", 
    "availability_90", 
    "availability_365", 
    "calendar_last_scraped", 
    "instant_bookable"
) FROM './data/v2.0/availability_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the min_max_night table
COPY "min_max_night" (
    "listing_id", 
    "minimum_nights", 
    "maximum_nights", 
    "minimum_minimum_nights", 
    "maximum_minimum_nights", 
    "minimum_maximum_nights", 
    "maximum_maximum_nights", 
    "minimum_nights_avg_ntm", 
    "maximum_nights_avg_ntm"
) FROM './data/v2.0/min_max_night_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the listing_reviews table
COPY "listing_reviews" (
    "listing_id", 
    "number_of_reviews", 
    "number_of_reviews_ltm", 
    "number_of_reviews_l30d", 
    "first_review", 
    "last_review", 
    "review_scores_rating", 
    "review_scores_accuracy", 
    "review_scores_cleanliness", 
    "review_scores_checkin", 
    "review_scores_communication", 
    "review_scores_location", 
    "reviews_per_month", 
    "review_scores_value"
) FROM './data/v2.0/listing_reviews_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the reviews table
COPY "reviews" (
    "review_id", 
    "listing_id", 
    "review_date", 
    "reviewer_id", 
    "reviewer_name", 
    "review_comments"
) FROM './data/v2.0/reviews_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- COPY command for the calendar table
COPY "calendar" (
    "id", 
    "listing_id", 
    "date", 
    "available", 
    "price", 
    "minimum_nights", 
    "maximum_nights"
) FROM './data/v2.0/calendar_cleaned.csv' 
DELIMITER ',' 
CSV HEADER;

-- DELETE commands, for removing the entire database (to create a fresh one)
-- Use with caution, obviously
DROP INDEX IF EXISTS idx_lat_long;
DROP INDEX IF EXISTS idx_neighbourhood_id;
DRoP INDEX IF EXISTS idx_host_id;
DROP VIEW IF EXISTS map_listings;
DROP TABLE IF EXISTS calendar;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS listing_reviews;
DROP TABLE IF EXISTS min_max_night;
DROP TABLE IF EXISTS availability;
DROP TABLE IF EXISTS listings_categorical;
DROP TABLE IF EXISTS listings;
DROP TABLE IF EXISTS neighbourhoods;
DROP TABLE IF EXISTS host_listings_count;
DROP TABLE IF EXISTS hosts;