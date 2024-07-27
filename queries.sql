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