SELECT pg_size_pretty(pg_database_size('dc-airbnb-2.0')) AS database_size;

SELECT pg_size_pretty(pg_relation_size('calendar')) AS table_size;

vacuum;

vacuum full;


SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';

select * from reviews;

-- displays all info about a table's schema
-- replace with appropriate table name
SELECT
    column_name,
    data_type,
    character_maximum_length,
    is_nullable
FROM
    information_schema.columns
WHERE
    table_name = 'calendar'
ORDER BY
    ordinal_position;
	

	
-- The map's app.py query, with LEFT JOINs to make it function for now
SELECT * FROM listings
LEFT JOIN listing_description ON listings.listing_id = listing_description.id
LEFT JOIN listing_reviews ON listings.listing_id = listing_reviews.listing_id
LEFT JOIN hosts ON hosts.host_id = listings.host_id;

select * from listing_description
left join listings on listing_description.id = listings.listing_id
where id in 
	(select listing_id from listings
	where host_id =
		(select host_id from hosts
		where host_name = 'Michael'
		and host_total_listings_count = '9'));
		
SELECT * FROM listings
JOIN listing_description ON listings.listing_id = listing_description.id
JOIN listing_reviews ON listings.listing_id = listing_reviews.listing_id
LEFT JOIN hosts ON hosts.host_id = listings.host_id
where id in 
	(select listing_id from listings
	where host_id =
		(select host_id from hosts
		where host_name = 'Michael'
		and host_total_listings_count = '9'));
	