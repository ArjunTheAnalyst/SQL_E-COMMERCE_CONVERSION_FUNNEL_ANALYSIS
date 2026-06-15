/* ============================================================
   SECTION 3: TIME-TO-CONVERSION ANALYSIS

   Objective:
   Measure the average time required for users to move
   through the purchasing journey during the most recent
   30-day analysis period.

   Metrics Calculated:
   - Number of converted users
   - Average time from View to Cart
   - Average time from Cart to Purchase
   - Average time from View to Purchase

   Note:
   Analysis is restricted to users who completed
   at least one purchase.
============================================================ */

WITH user_journey AS
(SELECT
	[user_id],

	-- FIRST PRODUCT VIEW
	MIN(CASE
		WHEN event_type LIKE 'page_view'
		THEN event_date
		ELSE NULL END) AS first_view_date,

	-- FIRST ADD-TO-CART EVENT
	MIN(CASE
		WHEN event_type LIKE 'add_to_cart'
		THEN event_date
		ELSE NULL END) AS first_cart_date,

	-- FIRST PURCHASE EVENT
	MIN(CASE
		WHEN event_type LIKE 'purchase'
		THEN event_date
		ELSE NULL END) AS first_purchase_date
FROM
	user_events
WHERE
	event_date >=
	DATEADD
	(
		DAY,
		-30,
		(SELECT MAX(CAST(event_date AS DATE)) FROM user_events)
	)
GROUP BY
	[user_id]),

purchasing_users AS
(SELECT
	*
FROM
	user_journey
WHERE
	first_purchase_date IS NOT NULL),

journey_duration_metrics AS
(SELECT
	COUNT([user_id]) AS converted_user_count,
	ROUND(
	AVG(
	CAST(DATEDIFF(MINUTE, first_view_date, first_cart_date) AS FLOAT)
	), 2) AS avg_view_to_cart_minutes,

	ROUND(
	AVG(
	CAST(DATEDIFF(MINUTE, first_cart_date, first_purchase_date) AS FLOAT)
	), 2) AS avg_cart_to_purchase_minutes,

	ROUND(
	AVG(
	CAST(DATEDIFF(MINUTE, first_view_date, first_purchase_date) AS FLOAT)
	), 2) AS avg_total_journey_minutes
FROM
	purchasing_users)

SELECT
	'Converted Users' AS metric,
	converted_user_count AS metric_value
FROM
	journey_duration_metrics
	
UNION ALL

SELECT
	'Average View to Cart (Minutes)' AS metric,
	avg_view_to_cart_minutes AS metric_value
FROM
	journey_duration_metrics

UNION ALL

SELECT
	'Average Cart to Purchase (Minutes)' AS metric,
	avg_cart_to_purchase_minutes AS metric_value
FROM
	journey_duration_metrics

UNION ALL

SELECT
	'Average Total Journey (Minutes)' AS metric,
	avg_total_journey_minutes AS metric_value
FROM
	journey_duration_metrics;


/*
=============================================================
TIME-TO-CONVERSION SUMMARY
=============================================================

| Metric                             | Value |
|------------------------------------|-------|
| Converted Users                    | 709   |
| Average View to Cart (Minutes)     | 11.21 |
| Average Cart to Purchase (Minutes) | 13.35 |
| Average Total Journey (Minutes)    | 24.56 |

=============================================================
KEY FINDINGS
=============================================================

1. A total of 709 users completed a purchase
   during the analysis period.

2. Users spend an average of 11.21 minutes
   between viewing a product and adding it
   to their cart.

3. Users spend an average of 13.35 minutes
   between adding an item to their cart and
   completing the purchase.

4. The average end-to-end customer journey
   lasts 24.56 minutes.

5. Browsing and checkout stages account for
   a relatively balanced share of the overall
   conversion journey.

=============================================================
BUSINESS INTERPRETATION
=============================================================

Purchasing users generally convert within a
single session, requiring less than 25 minutes
on average to progress from product discovery
to completed transaction.

The similarity between browsing time and
checkout time suggests that neither stage
introduces excessive friction for users who
eventually convert.

=============================================================
RECOMMENDATIONS
=============================================================

1. Monitor users with unusually long
   checkout durations to identify potential
   payment or UX issues.

2. Analyze non-converting users separately
   to understand where additional friction
   exists in the customer journey.

3. Consider targeted incentives for users
   who remain in the cart stage for extended
   periods without purchasing.

4. Segment journey durations by traffic
   source to identify channels that produce
   faster and higher-intent buyers.

=============================================================
*/