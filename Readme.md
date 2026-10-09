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

5. On further analysis of customer segment, Corporate customers generated the largest losses of $32,455
and -11.89% profit margin within the table sub-category 

6. The geographical losses are concentrated in APAC regional market specifically in Pakistan and South Korea. 
These locations generated extremely negative profit margins in some cases exceeding -200%, indicating that
losses significantly exceeded sales revenue.

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

