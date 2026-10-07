CREATE DATABASE global_superstore_sales;
USE global_superstore_sales;

-- Adding constraints
ALTER TABLE shipping
ADD PRIMARY KEY (ShippingID);

ALTER TABLE location
ADD PRIMARY KEY (LocationID);

ALTER TABLE orders
ADD CONSTRAINT fk_shipping
FOREIGN KEY (ShippingID)
REFERENCES shipping(ShippingID);

-- changing the datatype for order date and ship date
UPDATE orders
SET OrderDate = STR_TO_DATE(OrderDate, '%m/%d/%y');

ALTER TABLE orders
MODIFY OrderDate DATE;

UPDATE orders
SET ShipDate = STR_TO_DATE(ShipDate, '%m/%d/%y');

ALTER TABLE orders
MODIFY ShipDate DATE;

-- view the tables
SELECT * FROM location;

SELECT * FROM orders;

SELECT * FROM products;

SELECT * FROM customers;

SELECT * FROM shipping;

/* How can Global Superstore increase profitability while maintaining sales growth? */
-- 1. Executive KPIs
-- a. Total sales, profit and Profit Margin %
SELECT ROUND(SUM(sales)/1000000, 2) as TotalSales_millions,
		ROUND(SUM(profit)/1000000, 2) as TotalProfit_millions,
        ROUND((sum(profit)/sum(sales)) * 100, 2) as ProfitMargin
FROM orders;

-- b. Total orders, total customers and Average Order Value (AOV)
SELECT COUNT(DISTINCT OrderID) as TotalOrders,
	   COUNT(DISTINCT CustomerID) as TotalCustomers,
       ROUND(SUM(sales)/COUNT(DISTINCT orderID), 2) as avg_order_value
FROM orders;


-- 2. Sales Vs Profit Analysis
-- a. Sales, Profit, Profit Margin by Category
SELECT Category, 
		ROUND(SUM(o.sales/1000000), 2) AS TotalSales_millions, 
        ROUND(SUM(o.profit/1000000), 2) AS TotalProfit_millions,
        ROUND((SUM(o.profit)/SUM(o.sales)) * 100, 2) AS ProfitMargin
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
GROUP BY p.Category 
ORDER BY ProfitMargin DESC;

-- b. Sales, Profit and Profit margin by Sub-Category
SELECT p.Category, p.SubCategory, 
		ROUND(SUM(o.sales/1000000), 2) as TotalSales_millions,
        ROUND(SUM(o.profit/1000000), 2) as TotalProfit_millions,
        ROUND((SUM(o.profit)/SUM(o.sales)) * 100, 2) AS ProfitMargin
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
GROUP BY p.Category, p.SubCategory
ORDER BY TotalSales_millions DESC;

-- 3. Product Analysis
-- a. top loss-making table products
SELECT p.ProductName, 
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables' 
GROUP BY p.ProductName
HAVING TotalProfit_millions < 0
ORDER BY TotalProfit_millions ASC;

-- b. top profitable table products
SELECT p.ProductName, 
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables' 
GROUP BY p.ProductName
HAVING TotalProfit_millions > 0
ORDER BY TotalProfit_millions DESC;


-- 4. Discount Analysis
-- a. Total sales and Profit margin of discounted Table products VS non-discounted Tables
SELECT CASE WHEN Discount = 0 THEN 'No Discount'
			 WHEN Discount = 1 THEN 'Discounted'
	   ELSE 'Invalid value' END as Discount,
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions,
        ROUND((SUM(o.profit)/SUM(o.sales)) * 100, 2) as ProfitMargin
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables'
GROUP BY o.Discount;

-- b. product metrics for Tables subcategory for non discounted products showing losses
SELECT p.ProductName, o.Quantity,
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables' AND o.Discount = 0 
GROUP BY p.ProductName, o.Quantity
HAVING TotalProfit_millions < 0
ORDER BY TotalSales_millions DESC; 

-- c. product metrics for Tables subcategory for non discounted products showing profit
SELECT p.ProductName, o.Quantity,
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables' AND o.Discount = 0 
GROUP BY p.ProductName, o.Quantity
HAVING TotalProfit_millions > 0
ORDER BY TotalSales_millions DESC; 

-- d. product metrics for Tables category for discounted products showing losses
SELECT p.ProductName, o.Quantity,
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables' AND o.Discount = 1 
GROUP BY p.ProductName, o.Quantity
HAVING TotalProfit_millions < 0
ORDER BY TotalProfit_millions ASC; 

-- e. product metrics for Tables category for discounted products showing profit
SELECT p.ProductName, o.Quantity,
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions
FROM orders o LEFT JOIN products p 
			  ON o.ProductID = p.ProductID
WHERE SubCategory = 'Tables' AND o.Discount = 1 
GROUP BY p.ProductName, o.Quantity
HAVING TotalProfit_millions > 0
ORDER BY TotalProfit_millions ASC; 

-- 5. Customer Analysis
-- a. customers generating the largest losses in Tables 
SELECT c.Segment,
		ROUND(SUM(o.sales), 2) as TotalSales_millions,
        ROUND(SUM(o.profit), 2) as TotalProfit_millions,
        ROUND((SUM(o.profit)/SUM(o.sales))* 100, 2) as ProfitMargin
FROM orders o LEFT JOIN products p
			  ON o.ProductID = p.ProductID
              LEFT JOIN customers c
              ON o.CustomerID = c.CustomerID
WHERE SubCategory = 'Tables' 
GROUP BY c.Segment
ORDER BY TotalProfit_millions ASC;

-- 6. Geographic Analysis
-- a. markets generating largest Table losses
SELECT l.RegionalMarket, l.Region, l.Country, l.State,
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit,
        ROUND((SUM(o.profit)/SUM(o.sales))* 100, 2) as ProfitMargin
FROM orders o LEFT JOIN products p
			  ON o.ProductID = p.ProductID
              LEFT JOIN location l
              ON o.LocationID = l.LocationID
WHERE SubCategory = 'Tables' 
GROUP BY l.RegionalMarket, l.Region, l.Country, l.State
HAVING TotalProfit < 0
ORDER BY ProfitMargin ASC;


/* Findings:
1. Technology and furniture both has high sales but in terms of profit furniture 
shows some problem.

2. Phones generated  highest sales ($1.88M) in technology category with profit
of $230K and profit margin 12.44% .

3. Table sales are 3rd higher sales ($ 840K) in furniture category but not profiting ($70K loss) 
with -8.63% Profit margin. This shows why furniture have profit problem.

4. The Table category had overall profit margin of -8.63%. The product Level analysis showed that some 
Table products are highly profitable while others are highly loss-making. This suggests the entire 
Tables category is not a problem only specific products within the category are. Moreover, 
non-discounted tables are slightly unprofitable (-0.51%), discounted Tables lose money at a much 
faster rate (-117.21%). Furthermore, there was no profit on discounted Table subcategory.

5.On further analysis of customer segment, Corporate customers generated the largest losses of $32,455
and -11.89% profit margin within the table sub-category 

6. The geographical losses are concentrated in APAC regional market specifically in Pakistan and South Korea. 
These locations generated extremely negative profit margins in some cases exceeding -200%, indicating that
losses significantly exceeded sales revenue. */


/* Recommendation:
1. Review persistently loss-making table products and consider repricing, renegotiating supplier costs, or discontinuing
products that consistently fail to achieve acceptable margins.

2. Implement stricter controls over discounts for table products. Discounted table sales generate significantly worse profit margins
that non-discounted sales and should be carefully evaluated before approval.

3. Review corporate customer pricing and promotional agreements to identify opportunities to improve
profitability within the highest-loss customer segment.

4. Increase investment in high-performing categories and sub-categories such as Technology, Phones, Accessories, Paper, and Labels that consistently 
generate strong profit margins.

5. Conduct detailed regional reviews in high-loss areas to understand whether pricing, logistics, discounts, or local
market conditions are contributing to weak profitability.

6. Establish ongoing profitability monitoring at product level to identify loss-making products early and support more informed pricing 
and inventory decisions.
*/



