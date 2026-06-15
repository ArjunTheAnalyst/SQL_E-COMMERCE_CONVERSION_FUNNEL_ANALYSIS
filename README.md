# 🛒 E-Commerce Conversion Funnel Analysis (SQL)

## 📌 Project Overview

This project analyzes customer behavior across an e-commerce conversion funnel using SQL.

The objective is to understand how users progress from their initial website visit through cart activity, checkout, and final purchase. The analysis identifies conversion bottlenecks, evaluates acquisition channel effectiveness, measures customer journey duration, and assesses revenue performance.

The project demonstrates how SQL can be used to transform raw event-level data into actionable business insights that support marketing, product, and growth decisions.

---

## 🎯 Business Questions

This analysis answers the following questions:

- Where do users drop off within the purchase funnel?
- Which marketing channels generate the highest-quality traffic?
- How long does it take users to complete a purchase?
- How efficiently is website traffic converted into revenue?
- What opportunities exist to improve conversion and business performance?

---

## 🗂️ Dataset

The dataset contains user-level event data representing interactions throughout the customer journey.

### Key Fields

| Column | Description |
|----------|-------------|
| user_id | Unique customer identifier |
| event_type | User action performed |
| event_date | Timestamp of activity |
| traffic_source | Acquisition channel |
| amount | Revenue generated from purchases |

> ⚠️ **Note:** The dataset used for this analysis is not included in the repository.

> This project is intended to showcase SQL proficiency through the application of funnel analytics, customer journey analysis, revenue reporting, and business KPI development. The analytical framework can be readily applied to comparable event-based datasets.

### Funnel Events

- page_view
- add_to_cart
- checkout_start
- payment_info
- purchase

---

## 🛠️ SQL Skills Demonstrated

- Common Table Expressions (CTEs)
- Conditional Aggregation
- Window Functions
  - LAG()
  - FIRST_VALUE()
- Date Filtering
- Funnel Analysis
- Customer Journey Analytics
- Revenue KPI Analysis
- UNION ALL Reporting
- Data Transformation (Wide-to-Long)
- Business-Oriented SQL Reporting

---

## 📊 Analysis Performed

### 1️⃣ Overall Conversion Funnel Analysis

Analyzed user progression through:

1. Page View
2. Add to Cart
3. Checkout Start
4. Payment Information
5. Purchase

Metrics calculated:

- Users at each stage
- Stage-to-stage conversion rates
- Overall funnel conversion rates
- Funnel drop-off percentages

### 2️⃣ Traffic Source Performance

Compared acquisition channels using:

- View-to-Cart Conversion Rate
- Cart-to-Purchase Conversion Rate
- Overall Purchase Conversion Rate

Traffic sources analyzed:

- Email
- Paid Ads
- Organic Search
- Social Media

### 3️⃣ Time-to-Conversion Analysis

Measured how long purchasing users take to complete the buying journey.

Metrics calculated:

- Converted User Count
- Average View-to-Cart Duration
- Average Cart-to-Purchase Duration
- Average Total Journey Duration

### 4️⃣ Revenue Performance Analysis

Calculated key monetization metrics:

- Total Visitors
- Total Buyers
- Total Orders
- Total Revenue
- Average Order Value (AOV)
- Revenue per Visitor
- Revenue per Buyer

---

## 🔍 Key Findings

### Funnel Performance

| Stage | Users | Overall Conversion |
|---------|---------:|---------:|
| Page View | 4,291 | 100.00% |
| Add to Cart | 1,338 | 31.18% |
| Checkout Start | 954 | 22.23% |
| Payment Information | 770 | 17.94% |
| Purchase | 709 | 16.52% |

- Largest drop-off occurs between **Page View** and **Add to Cart**.
- **68.82%** of visitors leave before adding a product to their cart.
- Overall visitor-to-purchase conversion rate is **16.52%**.

### Traffic Source Performance

| Traffic Source | Overall Conversion |
|---------------|-------------------:|
| Email | 33.85% |
| Paid Ads | 21.00% |
| Organic | 17.07% |
| Social | 6.66% |

- 📧 Email marketing generates the highest-quality traffic.
- 📱 Social media traffic shows the weakest conversion performance.

### Customer Journey Insights

- ⏱️ Average View-to-Cart Time: **11.21 minutes**
- ⏱️ Average Cart-to-Purchase Time: **13.35 minutes**
- ⏱️ Average Total Journey Time: **24.56 minutes**

Most purchasing users complete the entire buying process within a single session.

### Revenue Insights

| KPI | Value |
|------|------:|
| Total Visitors | 4,291 |
| Total Buyers | 709 |
| Average Order Value | 107.46 |
| Revenue per Visitor | 17.76 |

- 💰 Revenue generation is driven primarily by first-time purchasers.
- 💰 Average Order Value is **107.46**.

---

## 💡 Business Recommendations

### Improve Product Page Performance

Potential improvements:

- Better product descriptions
- Improved product imagery
- Pricing optimization
- Stronger call-to-action placement

### Expand Email Marketing

📧 Increase investment in email campaigns due to their superior conversion performance.

### Optimize Paid Advertising

🎯 Improve audience targeting, ad creatives, and landing page relevance.

### Improve Social Traffic Quality

📱 Reassess targeting strategies and campaign objectives.

### Increase Customer Retention

Consider:

- Loyalty programs
- Post-purchase email campaigns
- Personalized offers
- Cross-selling and upselling initiatives

---

## 🚀 Skills Demonstrated

### Technical Skills

- SQL
- Window Functions
- CTEs
- Conditional Aggregation
- Funnel Analysis
- Revenue Analytics
- Customer Journey Analysis
- KPI Development

### Business Skills

- Conversion Optimization
- Marketing Analytics
- Revenue Analysis
- Customer Behavior Analysis
- Executive Reporting
- Data-Driven Decision Making

---

## 🏆 Project Outcome

This project demonstrates how SQL can be used to analyze customer behavior, identify conversion bottlenecks, evaluate marketing performance, and measure revenue efficiency.

The resulting insights can help stakeholders improve customer experience, optimize marketing investments, and drive sustainable business growth.
