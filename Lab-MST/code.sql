--- Q1


SELECT c.customer_name, c.city, SUM(o.amount) AS total_purchase
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING SUM(o.amount) >= (SELECT MAX(city_total)
FROM (SELECT c2.city, c2.customer_id, SUM(o2.amount) AS city_total
FROM Customer c2
JOIN Orders o2 ON c2.customer_id = o2.customer_id
 WHERE c2.city = c.city GROUP BY c2.city, c2.customer_id
 ) );



-- Q2



CREATE OR REPLACE FUNCTION log_product_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_audit (product_id, product_name, action, timestamp)
    VALUES (NEW.product_id, NEW.product_name, 'PRODUCT ADDED', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_product_insert
AFTER INSERT ON product_inventory
FOR EACH ROW
EXECUTE FUNCTION log_product_insert();

CREATE OR REPLACE FUNCTION log_product_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_audit (product_id, product_name, action, timestamp)
VALUES (OLD.product_id, OLD.product_name, 'PRODUCT REMOVED', CURRENT_TIMESTAMP);
RETURN OLD;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER after_product_delete
AFTER DELETE ON product_inventory
FOR EACH ROW

EXECUTE FUNCTION log_product_delete();





INSERT INTO product_inventory (product_id, product_name, price)
VALUES(70081, 'Dell Laptop', 79800);

SELECT * from product_audit;

