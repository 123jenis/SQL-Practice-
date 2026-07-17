-- Q1. List the product_name and price of all products that cost less than 5000.

CREATE VIEW medium_Cost AS
SELECT product_name, price
FROM products
WHERE price < 5000;
SELECT * FROM medium_Cost;

-- Q2. Find the total number of products in each category.

CREATE VIEW sell_product AS
SELECT COUNT(product_name), category
FROM products
GROUP BY category;
SELECT * FROM sell_product;

-- Q3. List all products where is_available is false.

CREATE VIEW not_available AS
SELECT *
FROM products
WHERE is_available = 'false';
SELECT * FROM not_available;

-- Q4. Find the product_name and stock_quantity of products with stock less than 40, sorted from lowest stock to highest.

CREATE VIEW list AS
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 80
ORDER BY stock_quantity
ASC;
SELECT * FROM list;

-- Q5. Create a view called expensive_electronics that shows product_name, price, and category 
-- for all products in the 'Electronics' category priced above 10000.

CREATE VIEW Expensive_Electronics AS 
SELECT product_name, price, category
FROM products
WHERE category = 'Electronics' AND price > 350;
SELECT * FROM Expensive_Electronics;


-- PROCEDURES

-- Q6.Create a procedure called update_price that takes product_id and new_price as parameters, and updates the price of that product.

CREATE PROCEDURE update_price (
	p_product_id INT,
	p_new_price NUMERIC(10,2)
)
LANGUAGE plpgsql
AS 
$$
BEGIN
	UPDATE products
	SET price = p_new_price
	WHERE product_id = p_product_id;
END;
$$;
CALL update_price(1, 9999.00);
SELECT * FROM products;

-- Q7.Create a procedure called restock_product that takes product_id and qty as parameters, and increases the stock_quantity by that amount.
CREATE PROCEDURE restock_product(
	p_product_id INT,
	p_qty INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
	UPDATE products
	SET stock = stock + p_qty
	WHERE product_id = p_product_id;
END;
$$;
CALL restock_product(2, 100);
SELECT * FROM products;

-- Q8. Create a procedure called mark_unavailable that takes product_id as a parameter and sets is_available to false for that product.
CREATE PROCEDURE mark_unavailable(
	p_product_id INT
)
LANGUAGE plpgsql
AS
$$
BEGIN
	UPDATE products
	SET is_available = false
	WHERE product_id = p_product_id;
END;
$$;
CALL mark_unavailable(6);
SELECT * FROM products;


-- Q9. Create a procedure called add_new_product that takes product_name, sku_code, price, stock_quantity, and category as parameters, and inserts a new row into the products table.
CREATE PROCEDURE add_new_product (
	p_product_name VARCHAR(50),
	p_sku_code CHAR(10),
	p_price NUMERIC(8,2),
	p_stock INT,
	is_available BOOLEAN,
	p_category VARCHAR(50),
	p_price_tag NUMERIC(10,3)
)
LANGUAGE plpgsql
AS
$$
BEGIN
	INSERT INTO products (	
			product_name,
			sku_code,
			price,
			stock,
			is_available,
			category,
			price_tag) 
	VALUES(
			p_product_name,
			p_sku_code,
			p_price,
			p_stock,
			is_available,
			p_category,
			p_price_tag
	);
END;
$$;
CALL add_new_product('Fan', 'kri56987', 5689.00, 101, 'False', 'Electronics', 5624.212);
SELECT * FROM products;


-- Q10. Create a procedure called apply_discount that takes category and discount_percent as parameters, and reduces the price by that percentage for all products in that category.
-- Try writing the CREATE PROCEDURE syntax for these — send me your answers and I'll check them one by one.

CREATE PROCEDURE apply_discount (
 	p_category TEXT,
	p_discount_percentage NUMERIC
)
LANGUAGE plpgsql
AS
$$
BEGIN 
	UPDATE products
	SET price = price - (price * p_discount_percentage / 100)
	WHERE category = p_category;
END;
$$;
CALL apply_discount('Electronics', 15);
SELECT * FROM products;








