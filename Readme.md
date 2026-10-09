# Retail Sales Analysis Using SQL

## Project Overview
### Business Problem
Profitability Improvement

### Problem Statement
Despite generating strong global sales, management wants to understand why profitability varies across products, customers, and regions and identify opportunities to improve profit growth.

The objective is to identify:

- Sales trends
- Top performing products
- Customer behaviour
- Regional performance
- Profitability insights

## Dataset
This project analyses a global retail sales dataset using SQL. The dataset was downloaded from Kaggle. Global Superstore Dataset

## Tools Used
- Draw.io 
- SQL (MySQL)
- MySQL Workbench
- GitHub

## Data Model
ERD Diagram


![SuperStore](https://github.com/Jjadhavpriyanka/Retail-Sales-Analysis-SQL/blob/main/screenshots/ERD%20/ERD-Global%20SuperStore%20Sales.drawio.png)

## Analysis Process
- Data cleaning
- Normalisation
- SQL Analysis

## Analysis Questions

1. Executive KPIs
   
    a. Total sales and profit?
   
    b. Profit Margin %
   
    c. Total orders and total customers
   
    d. Average Order Value
   
2. Sales Vs Profit Analysis
   
    a. Sales by Category
   
    b. Profit by Category
   
    c. Profit Margin by Category
   
    d. Sales by Sub-Category
   
    e. Profit by Sub-Category
   
    f. Profit Margin by Sub-Category
   
3. Product Analysis
   
    a. Top loss-making products for Tables sub-Category
   
    b. Top profitable products for Tables sub-Category
   
4. Discount Analysis
   
    a. Total sales and Profit margin of discounted Table products VS non-discounted Tables
   
    b. Product metrics for Tables subcategory for non discounted products showing losses
   
    c. Product metrics for Tables subcategory for non discounted products showing profit
   
    d. Product metrics for Tables category for discounted products showing losses
   
    e. Product metrics for Tables category for discounted products showing profit
   
5. Customer Analysis
   
    a. Customers generating the largest losses in Tables
   
6. Geographic Analysis
   
    a. Markets generating largest Table losses
   

## Key Findings
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

8. Customer analysis, Corporate customers generated the largest losses of $0.22M and -4.41% profit margin with no discount 
and when discounted all the segments showed losses with consumer being the highest (-120%) within the table sub-category.

9. The geographical losses were concentrated in APAC and EU region specifically in Pakistan and South Korea in APAC and 
Germany in EU irrespective of discount. These locations generated extremely negative profit margins when givne discount in 
some cases exceeding -200%, indicating that losses significantly exceeded sales revenue.

## Business Recommendations
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

## Dashboard Screenshots

