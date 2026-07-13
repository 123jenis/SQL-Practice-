-- Q1
SELECT product_name,price
FROM products
ORDER BY price 
ASC
LIMIT 1;

-- Q2
SELECT AVG(price)
FROM products
WHERE category IN ('Accessories', 'Bags');

-- Q3
SELECT product_name, stock
FROM products
WHERE stock > 50 AND price != 299;

-- Q4
SELECT Product_name, category, price
FROM products p
WHERE price = (
    SELECT MAX(price) 
    FROM products 
    WHERE category = p.category
);

-- Q5 
SELECT DISTINCT UPPER(category)
FROM products
ORDER BY 1 
DESC;

SELECT UPPER(category)
FROM products
ORDER BY 1
DESC;