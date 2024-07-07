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
    table_name = 'hosts'
ORDER BY
    ordinal_position;
	
-- The map's app.py query, with LEFT JOINs to make it function for now
SELECT * FROM listings
LEFT JOIN listing_description ON listings.listing_id = listing_description.id
LEFT JOIN listing_reviews ON listings.listing_id = listing_reviews.listing_id
LEFT JOIN hosts ON hosts.host_id = listings.host_id;