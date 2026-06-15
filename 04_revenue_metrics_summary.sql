/* ============================================================
   SECTION 4: REVENUE PERFORMANCE METRICS

   Objective:
   Measure overall revenue generation and monetization
   efficiency during the most recent 30-day period.

   Metrics Calculated:
   - Total Visitors
   - Total Buyers
   - Total Orders
   - Total Revenue
   - Average Order Value (AOV)
   - Average Revenue per Visitor
   - Average Revenue per Buyer

   Scope:
   Analysis includes all user activity recorded within
   the latest rolling 30-day period.
============================================================ */

WITH revenue_summary AS
(SELECT
	
	-- UNIQUE VISITORS REACHING THE WEBSITE
	COUNT(DISTINCT
	CASE
		WHEN event_type LIKE 'page_view' 
		THEN [user_id]
		ELSE NULL END) AS total_visitor_count,
	
	-- UNIQUE USERS COMPLETING A PURCHASE
	COUNT(DISTINCT
	CASE
		WHEN event_type LIKE 'purchase' 
		THEN [user_id]
		ELSE NULL END) AS total_buyer_count,

	-- TOTAL PURCHASE TRANSACTIONS
	COUNT(CASE
		WHEN event_type LIKE 'purchase'
		THEN 1
		ELSE NULL END) AS total_order_count,
		
	-- TOTAL REVENUE GENERATED
	ROUND(
	SUM(CASE
		WHEN event_type LIKE 'purchase'
		THEN amount
		ELSE 0 END), 2) AS total_revenue_amount
FROM
	user_events
WHERE
	event_date >=
	DATEADD
	(
		DAY,
		-30,
		(SELECT MAX(CAST(event_date AS DATE)) FROM user_events)
	)),

revenue_metrics AS
(SELECT
	total_visitor_count,
	total_buyer_count,
	total_order_count,
	total_revenue_amount,

	-- AVERAGE REVENUE GENERATED PER ORDER
	ROUND(
	total_revenue_amount
	/
	total_order_count, 2) AS average_order_value,

	-- AVERAGE REVENUE GENERATED PER VISITOR
	ROUND(
	total_revenue_amount
	/
	total_visitor_count, 2) AS average_revenue_per_visitor,

	-- AVERAGE REVENUE GENERATED PER BUYER
	ROUND(
	total_revenue_amount
	/
	total_buyer_count, 2) AS average_revenue_per_buyer
FROM
	revenue_summary)

SELECT
	'Total Visitors' AS metric,
	total_visitor_count AS metric_value
FROM
	revenue_metrics

UNION ALL

	SELECT
	'Total Buyers' AS metric,
	total_buyer_count AS metric_value
FROM
	revenue_metrics
	
UNION ALL

	SELECT
	'Total Orders' AS metric,
	total_order_count AS metric_value
FROM
	revenue_metrics
	
UNION ALL

	SELECT
	'Average Order Value' AS metric,
	average_order_value AS metric_value
FROM
	revenue_metrics
	
UNION ALL

	SELECT
	'Average Revenue per Visitor' AS metric,
	average_revenue_per_visitor AS metric_value
FROM
	revenue_metrics
	
UNION ALL

	SELECT
	'Average Revenue per Buyer' AS metric,
	average_revenue_per_buyer AS metric_value
FROM
	revenue_metrics;


/*
=============================================================
REVENUE PERFORMANCE SUMMARY
=============================================================

| Metric                      | Value	 |
|-----------------------------|----------|
| Total Visitors              | 4,291    |
| Total Buyers                | 709      |
| Total Orders                | 709      |
| Average Order Value         | 107.46   |
| Average Revenue per Visitor | 17.76    |
| Average Revenue per Buyer   | 107.46   |

=============================================================
KEY FINDINGS
=============================================================

1. The business generated revenue from
   709 unique buyers during the period.

2. Total orders and total buyers are equal.

   - This indicates no repeat purchases
     occurred within the analysis window.

3. Average Order Value (AOV) is 107.46.

   - Each completed transaction generated
     approximately 107.46 in revenue.

4. Average Revenue per Visitor is 17.76.

   - Every website visitor contributed
     17.76 in revenue on average.

5. Average Revenue per Buyer is 107.46.

   - Revenue per buyer matches AOV due to
     the one-order-per-buyer relationship.

=============================================================
BUSINESS INTERPRETATION
=============================================================

Revenue generation is primarily driven by
first-time purchasers. While conversion volume
is healthy, there is limited evidence of repeat
purchasing behavior within the observed period.

The relatively strong Average Order Value
suggests that customers who complete purchases
generate meaningful revenue per transaction.

=============================================================
RECOMMENDATIONS
=============================================================

1. Implement customer retention initiatives
   to encourage repeat purchases.

2. Launch post-purchase email campaigns
   targeting existing buyers.

3. Introduce loyalty or rewards programs
   to increase customer lifetime value.

4. Explore upselling and cross-selling
   opportunities to further increase
   Average Order Value.

5. Continue monitoring Revenue per Visitor
   alongside funnel conversion metrics to
   evaluate overall monetization efficiency.

=============================================================
*/