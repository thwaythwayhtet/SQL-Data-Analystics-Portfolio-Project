## 🧠 SQL-Data-Analystics-Portfolio-Project

✨ <u>About this project</u>

**🎯 Objective** <br>
To develop a structured SQL repository that demonstrates practical data analytics skills, including data exploration, metric development, time-based analysis, and customer and product segmentation, while showcasing best practices for transforming raw data into actionable business insights.  <br><br>


**🗄️ Database** 
*	SQL Platform: MySQL
*	Key Tables: dim_product, dim_customer, fact_sales
* Source: Data with Baraa - [Advanced Data Analytics Project ](https://www.datawithbaraa.com/wiki/sql#sql-welcome)
* Super cool guided project 😎 - [check out the full video on YouTube: “Data with Baraa”.](https://www.youtube.com/watch?v=2jGhQpbzHes&t=2652s)   <br><br>


**🧰 Tools & Skills**
*	SQL (Complex Queries, Window Functions, CTE, Subqueries) 
* Advance Analytics
    * Change-Over-Time (Trends)
    * Cumulative Analysis
    * Performance Analysis
    * Proportional Analysis
    * Data Segmentation
    * Reporting <br><br>

**⭐ Complete SQL Pipeline: From Raw Data to Business Insights**

**🔍 1. Change-Over-Time Analysis (Trends)**  <br>
*Note: To analyze how a measure evolves over time and identity seasonality in the data.* <br>

1. Changes over Year: A high-level overview insight that helps with strategic decision making (Performance by each year)
   > 2013 is the high performing year in terms of sales. <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/1.1.png) <br>


2. Changes over Month: Detailed insight to discover seasonality
   > December is the best month for sales due to Christmas and year-end holidays, whereas February is typically the weakest month. <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/1.3.png) <br>


**🔍 2. Cumulative Analysis** <br>

1. Calculate the total sales per month <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/2.1.1.png) <br>

2. Calculate the running total of sales over time <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/2.2.png) <br>

3. Calculate the moving average of price over time <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/2.3.png) <br>

**🔍 3. Performance Analysis** <br>

1. Current Sales vs Average Sales Performance <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/3.1.0.png) <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/3.1.1.png) <br>

2. Analyze the yearly performance of products by comparing their sales to both the average sales performance of the product and the previous year’s sales <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/3.1.2.png) <br>


**🔍 4. Proportional Analysis** <br>
*Note: To analyze how an individual part is performing compared to the overall, allowing us to understand which category has the greatest impact on the business*

1. Which categories contribute the most to overall sales. <br>
   > Most of the business Revenue comes from ‘Bike’ and the remaining categories are the minor contributors to business. This indicates a heavy reliance on a single category, which poses a risk to the business.
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/4.1.png) <br>

2. Which subcategories contribute the most to overall sales.
   > In terms of sub-category, road bikes contributed nearly 50% of the revenue share, followed by Mountain Bikes (34%) and Touring Bikes (13%) respectively. <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/4.2.png) <br>


**🔍 5. Data Segmentation** <br>
1. Segment products into cost ranges and count how many products fall into each segment <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/5.1.1.png) <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/5.1.2.png) <br>


2. Group customers into three segments based on their spending behavior. <br>
/* <br> 
-- VIP: at least 12 months of history and spending more than €5,000. <br>
-- Regular: at least 12 months of history but spending €5,000 or less. <br>
-- New: lifespan less than 12 months.  <br>
AND find the total number of customers by each group*/ <br>

![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/5.2.1.png) <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/5.2.2.png) <br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/5.2.3.png) <br>


**📋 6. Report Generation** <br> 

**1. Create an SQL VIEW to provide Customer Report** <br><br>
Purpose: 
*	This report consolidates key customer metrics and behaviors
Highlights: 
   1.	Gathers essentials fields such as names, ages and transaction details 
   2.	Segment customers into categories (VIP, Regular, New) and age groups.
   3.	Aggregates customer-level metrics:
       - total orders
     	 - total sales 
       - total quantity purchased 
       - total products 
       - lifespan (in months)
   5.	Calculates valuable KPIs:
      - Recency (months since last order)
      - Average order value
      - Average monthly spend


![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/6.1.1.png) <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/6.1.2.png) <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/6.1.3.png) <br><br>


**2. Product Report: Create an SQL VIEW to provide Product Insights** <br><br>
Purpose: 
* This report consolidates key product metrics and behaviors
Highlights: 
   1. Gathers essentials fields such as product name, category, subcategory and cost.
   2. Segment products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
   3. Aggregates product-level metrics:
      - total orders 
      - total sales 
      - total quantity sold
      - total customers (unique)
      - lifespan (in months)
   4. Calculates valuable KPIs: 
      - Recency (months since last sale)
      - Average order revenue (AOR)
      - Average monthly revenue

![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/6.2.1.png) <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/6.2.2.png) <br><br>
![database](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/images/6.2.3.png) <br><br>


👉 [Please check out SQL Query Code!](https://github.com/thwaythwayhtet/SQL-Data-Analystics-Portfolio-Project/blob/main/advanced_data_analytics_project.sql)










