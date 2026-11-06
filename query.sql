-- Check total records
SELECT COUNT(*) FROM swiggy;

-- Check for nulls in key columns
SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_names, 
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_ratings, 
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS null_cities
FROM swiggy;

-- Remove rows where rating is 'NEW' or '--' (not yet rated)
DELETE FROM swiggy
WHERE rating = 'NEW' OR rating = '--';

-- Standardise rating to numeric
UPDATE swiggy
SET rating = CAST(rating AS DECIMAL(2,1))
WHERE rating NOT IN ('NEW', '--');

-- Q1: How many restaurants are listed per city?
SELECT city, COUNT(*) AS total_restaurants
FROM swiggy
GROUP BY city
ORDER BY total_restaurants DESC
LIMIT 10;

-- Q2: What are the most popular cuisines across India?
SELECT cuisine, COUNT(*) AS count
FROM swiggy
GROUP BY cuisine
ORDER BY count DESC
LIMIT 10;

-- Q3: Which restaurant chains have the most branches?
SELECT name, COUNT(*) AS branches
FROM swiggy
GROUP BY name
ORDER BY branches DESC
LIMIT 10;

-- Q4: Top 5 cities with highest average restaurant rating?
SELECT 
    city, ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating, 
    COUNT(*) AS total_restaurants
FROM swiggy
GROUP BY city
HAVING COUNT(*) > 50
ORDER BY avg_rating DESC
LIMIT 5;

-- Q5: What is the average cost for two across cities?
SELECT 
    city, 
    ROUND(AVG(CAST(REPLACE(REPLACE(cost, ',',''), '₹', '') AS INTEGER)), 0) AS avg_cost
FROM swiggy
WHERE cost IS NOT NULL
GROUP BY city
ORDER BY avg_cost DESC
LIMIT 10;

-- Q6: Which cuisines have the highest average rating?
SELECT 
    cuisine, 
    ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating, 
    COUNT(*) AS restaurant_count
FROM swiggy
GROUP BY cuisine
HAVING COUNT(*) > 100
ORDER BY avg_rating DESC
LIMIT 10;

-- Q7: Restaurants with rating above 4.5 and more than 1000 ratings
WITH cleaned AS (
    SELECT
        name, city, rating, rating_count, cost,
        UPPER(field5) AS upper_rating_count,
        REPLACE(REPLACE(UPPER(field5), 'RATINGS', ''), '+', '') AS            cleaned_data
    FROM swiggy
),
parsed_data AS (
    SELECT
        *,
        CASE
            WHEN cleaned_data LIKE '%K%' THEN
				CAST(TRIM(REPLACE(cleaned_data, 'K', '')) AS REAL) *                  1000
            ELSE
                CAST(TRIM(cleaned_data) AS REAL)
        END AS cleaned_rating_count
    FROM cleaned
)

SELECT name, city, rating, cleaned_rating_count, cost 
FROM parsed_data
WHERE rating_count >= 1000 AND field5 >= 4.5
ORDER BY field4 DESC
LIMIT 20;

-- Q8: Business insight — which city has best value for money? (high rating, low cost)
SELECT city,
	   ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
	   ROUND(AVG(CAST(REPLACE(REPLACE(cost, ',',''), '₹', '') AS INTEGER)), 0) AS avg_cost
FROM swiggy
GROUP BY city
HAVING COUNT(*) > 30
ORDER BY avg_rating DESC, avg_cost ASC
LIMIT 10;