--Aggregating the stars into whole number AS Ratings
SELECT 
	CASE WHEN stars = 5 THEN 5
		 WHEN stars IN (4.9,4.8,4.7,4.6,4.5) THEN 5
	     WHEN stars IN (4.4,4.3,4.2,4.1,4,3.9,3.8,3.7,3.6) THEN 4
		 WHEN stars IN (3.5,3.4,3.3,3.2,3.1,3,2.9,2.8,2.7,2.6) THEN 3
		 WHEN stars IN (2.5,2.4,2.3,2.2,2.1,2,1.9,1.8,1.7,1.6,1.5) THEN 2
		 WHEN stars IN (1.4,1.3,1.2,1) THEN 1
		 ELSE stars
		 END AS Ratings
 FROM 
  amazon_products 

--Adding a new column (Ratings) to the table
ALTER TABLE amazon_products
ADD Ratings INT;

--Updating the new column 
UPDATE amazon_products
SET Ratings = CASE WHEN stars = 5 THEN 5
		 WHEN stars IN (4.9,4.8,4.7,4.6,4.5) THEN 5
	     WHEN stars IN (4.4,4.3,4.2,4.1,4,3.9,3.8,3.7,3.6) THEN 4
		 WHEN stars IN (3.5,3.4,3.3,3.2,3.1,3,2.9,2.8,2.7,2.6) THEN 3
		 WHEN stars IN (2.5,2.4,2.3,2.2,2.1,2,1.9,1.8,1.7,1.6,1.5) THEN 2
		 WHEN stars IN (1.4,1.3,1.2,1) THEN 1
		 ELSE stars
		 END 


-- Distribution of product ratings (stars)
SELECT Ratings, 
	  Count(*) AS Rating_Counts 
	FROM amazon_products 
	GROUP BY Ratings 
	ORDER BY Ratings DESC

-- Getting the Total Revenue for the month of September 2023
SELECT SUM(price)
	FROM amazon_products


 SELECT category_id, SUM(price)
	FROM amazon_products 
	GROUP BY category_id
	ORDER BY SUM(price) DESC


-- Distribution of product ratings by product category
SELECT c.category_name,  AVG(Ratings), 
  Count(*) AS Rating_Counts 
FROM amazon_products p 
  JOIN Amazon_Categories c ON p.category_id = c.id 
GROUP BY p.Ratings, c.category_name 
ORDER BY Ratings DESC;

-- Which product category has the highest average rating?
SELECT category_id, 
  AVG(stars) AS avg_rating 
FROM amazon_products 
GROUP BY category_id 
ORDER BY avg_rating DESC;


-- Distribution of product prices in the dataset
SELECT price, 
  COUNT(*) AS price_count 
FROM amazon_products 
GROUP BY price 
ORDER BY price;



-- Relationship between price and the number of reviews
SELECT price, AVG(reviews) AS avg_reviews 
FROM 
  amazon_products 
GROUP BY 
  price 
ORDER BY 
  avg_reviews DESC;

-- Count of best-selling products in each category
SELECT p.category_id, c.category_name, 
  COUNT(*) AS best_seller_count 
FROM amazon_products p 
  JOIN Amazon_Categories c ON p.category_id = c.id 
WHERE isBestSeller = 1 -- isbestseller column, 1 = TRUE while 0 = FALSE
GROUP BY category_id, c.category_name 
ORDER BY best_seller_count DESC;


-- Percentage of total sales contributed by best-selling products
SELECT 
  COUNT(CASE WHEN isBestSeller = 1 THEN 1 END) AS best_seller_count, 
  COUNT(*) AS total_products_count, 
  (
    COUNT(CASE WHEN isBestSeller = 1 THEN 1 END) * 100.0 / COUNT(*)
  ) AS percentage_of_total_sales 
FROM 
  amazon_products;