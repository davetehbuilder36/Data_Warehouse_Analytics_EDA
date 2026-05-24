# SQL Customer & Product Behavior Analytics Dashboard

## Project Overview
This project demonstrates an end-to-end SQL analytics workflow, starting from exploratory data analysis (EDA) and progressing into advanced business analytics reporting.

Using SQL Server, I analyzed transactional sales data, built customer and product analytical views, generated key business KPIs, segmented customers and products, and prepared the data for Power BI dashboard visualization.

The project simulates a real-world analytics pipeline used by data analysts and business intelligence teams.

<img width="1259" height="489" alt="image" src="https://github.com/user-attachments/assets/0e95acca-41c3-4e38-a8dd-cdb823fc738b" />

---

## Project Objectives
- Perform exploratory data analysis (EDA) on transactional sales data
- Analyze customer purchasing behavior
- Analyze product performance and lifecycle metrics
- Segment customers based on business value
- Segment products based on revenue performance
- Build reusable analytical SQL views for reporting
- Prepare data for Power BI dashboard development

---

## Tools & Technologies
- SQL Server
- T-SQL
- SQL Views / CTEs
- Power BI
- Data Warehousing Concepts
- Exploratory Data Analysis (EDA)
- Business Intelligence Reporting

---

## Project Workflow

### 1. Data Preparation
- Created analytics-ready SQL environment
- Loaded structured sales/customer/product datasets
- Validated schema relationships and data consistency

### 2. Exploratory Data Analysis (EDA)
Performed foundational business analysis including:

#### Database Exploration
- schema inspection
- table validation
- relationship verification

#### Dimension Analysis
- customers by country
- customers by gender
- products by category

#### Measure Analysis
- total sales
- total quantity sold
- average selling price
- total orders
- total products
- total customers

#### Ranking Analysis
- top-performing products
- lowest-performing products
- top customers by revenue

#### Time Analysis
- monthly sales trends
- cumulative sales growth
- change-over-time metrics

#### Segmentation Analysis
- product cost segmentation
- customer behavior segmentation

---

## Advanced Analytics

### Customer Analytics View
Built a final customer reporting view containing:

- customer identity details
- age and age groups
- total orders
- total sales
- total quantity purchased
- total unique products purchased
- customer lifespan
- recency analysis
- average sale value
- average monthly spend
- customer segmentation:
  - VIP
  - Regular
  - New

Example business questions answered:
- Who are the highest-value customers?
- Which customers are inactive?
- What customer segment drives most revenue?
- How does spending differ across age groups?

---

### Product Analytics View
Built a final product reporting view containing:

- product information
- category / subcategory
- cost
- total orders
- total sales
- total quantity sold
- total customers
- product lifespan
- recency since last sale
- average selling price
- average order revenue
- average monthly revenue
- product performance segmentation:
  - High Performer
  - Mid Range
  - Low Performer

Example business questions answered:
- Which products generate the most revenue?
- Which products are underperforming?
- Which categories contribute most to sales?
- Which products are becoming inactive?

---

## Power BI Dashboard
Interactive dashboard built using the final analytical SQL views.

Dashboard includes:
- executive KPI overview
- customer behavior analysis
- customer segmentation insights
- product performance analysis
- sales trends
- top customers/products
- recency & retention metrics

