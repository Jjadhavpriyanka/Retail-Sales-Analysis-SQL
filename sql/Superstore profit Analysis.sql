CREATE DATABASE global_superstore_sales;
USE global_superstore_sales;

-- changing date format for orderDate and shippingDate
ALTER TABLE orders
ADD COLUMN orderDate_change DATE;

UPDATE orders
SET orderDate_change = STR_TO_DATE(orderDate, '%c/%e/%Y');

ALTER TABLE orders
DROP COLUMN orderDate;

ALTER TABLE orders
CHANGE COLUMN orderDate_change orderDate DATE;

-- shipDate
ALTER TABLE orders
ADD COLUMN shipDate_change DATE;

UPDATE orders
SET shipDate_change = STR_TO_DATE(shipDate, '%c/%e/%Y');

ALTER TABLE orders
DROP COLUMN shipDate;

ALTER TABLE orders
CHANGE COLUMN shipDate_change shipDate DATE;


-- view the tables
SELECT * FROM storelocation;

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
-- year-over-year growth for orders
WITH yearly_cust_orders AS (SELECT YEAR(orderDate) AS orderYear, 
								   COUNT(DISTINCT OrderID) as TotalOrders,
								   COUNT(DISTINCT CustomerID) as TotalCustomers,
								   ROUND(SUM(sales)/COUNT(DISTINCT orderID), 2) as avg_order_value
							FROM orders
							GROUP BY orderYear 
							ORDER BY orderYear DESC)

SELECT orderYear, TotalOrders, 
	   LAG(TotalOrders) OVER(ORDER BY orderYear) AS previous_yr_orders,
	   ROUND((TotalOrders - LAG(TotalOrders) OVER(ORDER BY orderYear))/
			  LAG(TotalOrders) OVER(ORDER BY orderYear) * 100, 2) as order_Growth_rate
FROM yearly_cust_orders;

-- year-over-year growth for customers
WITH yearly_cust_orders AS (SELECT YEAR(orderDate) AS orderYear, 
								   COUNT(DISTINCT OrderID) as TotalOrders,
								   COUNT(DISTINCT CustomerID) as TotalCustomers,
								   ROUND(SUM(sales)/COUNT(DISTINCT orderID), 2) as avg_order_value
							FROM orders
							GROUP BY orderYear 
							ORDER BY orderYear DESC)

SELECT orderYear, TotalCustomers,
	   LAG(TotalCustomers) OVER(ORDER BY orderYear) AS previous_yr_orders,
	   ROUND((TotalCustomers - LAG(TotalCustomers) OVER(ORDER BY orderYear))/
			  LAG(TotalCustomers) OVER(ORDER BY orderYear) * 100, 2) as customer_Growth_rate
FROM yearly_cust_orders;

-- Average order value
SELECT YEAR(orderDate) AS orderYear,
	   ROUND(SUM(sales)/COUNT(DISTINCT orderID), 2) as avg_order_value
FROM orders
GROUP BY orderYear 
ORDER BY orderYear DESC;
    

-- 2. Sales Vs Profit Analysis
-- a. Sales, Profit, Profit Margin by Category
SELECT productCategory, 
		ROUND(SUM(o.sales/1000000), 2) AS TotalSales_millions, 
        ROUND(SUM(o.profit/1000000), 2) AS TotalProfit_millions,
        ROUND((SUM(o.profit)/SUM(o.sales)) * 100, 2) AS ProfitMargin
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
GROUP BY p.productCategory 
ORDER BY ProfitMargin DESC;

-- b. Sales, Profit and Profit margin by Sub-Category
SELECT p.productCategory, p.productSubcategory, 
		ROUND(SUM(o.sales/1000000), 2) as TotalSales_millions,
        ROUND(SUM(o.profit/1000000), 2) as TotalProfit_millions,
        ROUND((SUM(o.profit)/SUM(o.sales)) * 100, 2) AS ProfitMargin
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
GROUP BY p.productCategory, p.productSubcategory
ORDER BY TotalSales_millions DESC;

-- 3. Product Analysis
-- a. top loss-making table products
SELECT p.productName, 
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables' 
GROUP BY p.productName
HAVING TotalProfit < 0
ORDER BY TotalProfit ASC;

-- b. top profitable table products
SELECT p.ProductName, 
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables' 
GROUP BY p.ProductName
HAVING TotalProfit > 0
ORDER BY TotalProfit DESC;


-- 4. Discount Analysis
-- a. Total sales and Profit margin of discounted Table products VS non-discounted Tables
SELECT CASE WHEN discount = 0 THEN 'No Discount'
			 WHEN discount = 1 THEN 'Discounted'
	   ELSE 'Invalid value' END as discount,
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit,
        ROUND((SUM(o.profit)/SUM(o.sales)) * 100, 2) as ProfitMargin
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables'
GROUP BY o.discount;

-- b. product metrics for Tables subcategory for non discounted products showing losses
SELECT p.productName, 
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables' AND o.discount = 0 
GROUP BY p.ProductName
HAVING TotalProfit < 0
ORDER BY TotalProfit ASC; 

-- c. product metrics for Tables subcategory for non discounted products showing profit
SELECT p.ProductName, 
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables' AND o.discount = 0 
GROUP BY p.productName
HAVING TotalProfit > 0
ORDER BY TotalProfit DESC; 

-- d. product metrics for Tables category for discounted products showing losses
SELECT p.productName,
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables' AND o.discount = 1 
GROUP BY p.productName
HAVING TotalProfit < 0
ORDER BY TotalProfit ASC; 

-- e. product metrics for Tables category for discounted products showing profit
SELECT p.productName, 
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit
FROM orders o INNER JOIN products p 
			  ON o.productKey = p.productKey
WHERE productSubcategory = 'Tables' AND o.discount = 1 
GROUP BY p.productName
HAVING TotalProfit > 0
ORDER BY TotalProfit DESC; 

-- 5. Customer Analysis
-- a. customers generating the largest losses in Tables with discount
SELECT c.segment,
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit,
        ROUND((SUM(o.profit)/SUM(o.sales))* 100, 2) as ProfitMargin
FROM orders o INNER JOIN products p
			  ON o.productKey = p.productKey
              INNER JOIN customers c
              ON o.CustomerID = c.CustomerID
WHERE productSubcategory = 'Tables' AND o.discount = 1
GROUP BY c.segment
ORDER BY TotalProfit ASC;

-- b. customers generating the largest losses in Tables non-discounted
SELECT c.segment,
		ROUND(SUM(o.sales), 2) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit,
        ROUND((SUM(o.profit)/SUM(o.sales))* 100, 2) as ProfitMargin
FROM orders o INNER JOIN products p
			  ON o.productKey = p.productKey
              INNER JOIN customers c
              ON o.CustomerID = c.CustomerID
WHERE productSubcategory = 'Tables' AND o.discount = 0
GROUP BY c.segment
ORDER BY TotalProfit ASC;


-- 6. Geographic Analysis
SELECT * FROM storelocation;

SELECT * FROM orders;
-- a. Region generating largest Table losses when discounted
SELECT l.storeRegion, l.storeCountry, 
		SUM(o.sales) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit,
        ROUND((SUM(o.profit)/SUM(o.sales))* 100, 2) as ProfitMargin
FROM orders o INNER JOIN products p
			  ON o.productKey = p.productKey
              INNER JOIN storelocation l
              ON o.locationID = l.locationID
WHERE productSubcategory = 'Tables' AND o.discount = 1
GROUP BY l.storeRegion, l.storeCountry
ORDER BY ProfitMargin ASC;

-- b. Region generating largest Table losses when non-discounted
SELECT l.storeRegion, l.storeCountry, 
		SUM(o.sales) as TotalSales,
        ROUND(SUM(o.profit), 2) as TotalProfit,
        ROUND((SUM(o.profit)/SUM(o.sales))* 100, 2) as ProfitMargin
FROM orders o INNER JOIN products p
			  ON o.productKey = p.productKey
              INNER JOIN storelocation l
              ON o.locationID = l.locationID
WHERE productSubcategory = 'Tables' AND o.discount = 0
GROUP BY l.storeRegion, l.storeCountry
ORDER BY ProfitMargin ASC;




/* Findings:
1. Global Superstore generated $12.64M in sales and $1.47M in profit, achieving an overall profit margin of 11.61%.
The business is profitable and financially stable.

2. Technology delivered highest sales, profit, and profit margin, making it the strongest performing category in terms 
of both sales and profit.

3. Phones generated  highest sales ($1.70M) in technology category with profit of $220K and profit margin 12.69%.

4. Furniture generated substantial sales but produced significantly lower profit margins than Technology and Office 
Supplies, indicating inefficiencies in profitability rather than demand generation.

5. The Tables subcategory was the 3rd higher sales subcategory generating $760K with overall loss of $60K, producing 
a profit margin of -8.47% and significantly reducing the overall profitability of the Furniture category.

6. On further product analysis it was revealed that losses are driven by a group of specific Table products rather than 
the entire Tables subcategory. Several products generated strong sales while consistently producing negative profits. 
The issue might be product specific.

7. Moreover, non-discounted tables products are profitable (0.13%), discounted Tables lose money at a much faster rate 
(-116.29%) and non-of the Table products produced profit, suggesting that current discounting practices are contributing 
to losses rather than making profitable growth.

8.Customer analysis, Corporate customers generated the largest losses of $0.22M and -4.41% profit margin with no discount 
and when discounted all the segments showed losses with consumer being the highest (-120%) within the table sub-category.

9. The geographical losses were concentrated in APAC and EU region specifically in Pakistan and South Korea in APAC and 
Germany in EU irrespective of discount. These locations generated extremely negative profit margins when givne discount in 
some cases exceeding -200%, indicating that losses significantly exceeded sales revenue. */


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


