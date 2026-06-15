/* ============================================================
   SECTION 2: FUNNEL PERFORMANCE BY TRAFFIC SOURCE

   Objective:
   Compare conversion performance across acquisition
   channels to identify which traffic sources generate
   the highest quality users.

   Metrics Calculated:
   - View-to-Cart Conversion Rate
   - Cart-to-Purchase Conversion Rate
   - Overall Purchase Conversion Rate

   Analysis Window:
   Most recent 30 days based on the latest date
   available in the dataset.
============================================================ */

WITH traffic_source_funnel AS
(SELECT
	traffic_source,
	COUNT(DISTINCT CASE
		WHEN event_type LIKE 'page_view' 
		THEN [user_id]
		ELSE NULL END) AS page_view_users,

	COUNT(DISTINCT CASE
		WHEN event_type LIKE 'add_to_cart' 
		THEN [user_id]
		ELSE NULL END) AS add_to_cart_users,

	COUNT(DISTINCT CASE
		WHEN event_type LIKE 'purchase' 
		THEN [user_id]
		ELSE NULL END) AS purchase_users
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
	traffic_source)

SELECT
	traffic_source,
	page_view_users,
	add_to_cart_users,
	purchase_users,

	/* --------------------------------------------------------
	   Percentage of visitors who added a product to cart
	-------------------------------------------------------- */
	
	ROUND(
	(
	add_to_cart_users
	/
	CAST(
	page_view_users AS FLOAT) 
	) * 100, 2) AS view_to_cart_conversion_pct,

	/* --------------------------------------------------------
	   Percentage of cart users who completed a purchase
	-------------------------------------------------------- */

	ROUND(
	(
	purchase_users
	/
	CAST(
	add_to_cart_users AS FLOAT) 
	) * 100, 2) AS cart_to_purchase_conversion_pct,

	/* --------------------------------------------------------
	   Overall visitor-to-purchase conversion rate
	-------------------------------------------------------- */

	ROUND(
	(
	purchase_users
	/
	CAST(
	page_view_users AS FLOAT) 
	) * 100, 2) AS overall_conversion_pct
FROM
	traffic_source_funnel
ORDER BY
	overall_conversion_pct DESC;


/*
============================================================
TRAFFIC SOURCE PERFORMANCE SUMMARY
============================================================

| Traffic Source | View to Cart | Cart to Purchase | Overall Conversion |
|----------------|-------------	|------------------|--------------------|
| Email          | 63.03%		| 53.71%           | 33.85%             |
| Paid Ads       | 37.14%		| 56.54%           | 21.00%             |
| Organic        | 32.90%		| 51.90%           | 17.07%             |
| Social         | 13.56%		| 49.12%           | 6.66%              |

============================================================
KEY FINDINGS
============================================================

1. Email is the highest-performing acquisition channel.

   - 63.03% of visitors add products to cart.
   - 53.71% of cart users complete a purchase.
   - Overall conversion reaches 33.85%.

2. Paid Ads generate the second-best overall
   conversion performance.

   - 37.14% View-to-Cart conversion.
   - 56.54% Cart-to-Purchase conversion.
   - 21.00% overall conversion.

3. Organic traffic produces moderate results.

   - 32.90% View-to-Cart conversion.
   - 51.90% Cart-to-Purchase conversion.
   - 17.07% overall conversion.

4. Social media is the weakest acquisition source.

   - Only 13.56% of visitors add items to cart.
   - Overall conversion is just 6.66%.
   - Indicates weak visitor intent or targeting.

============================================================
BUSINESS INTERPRETATION
============================================================

Email marketing attracts the most qualified users,
demonstrating the strongest engagement and purchase
intent throughout the funnel.

Paid advertising performs reasonably well and may
benefit from further optimization to improve traffic
quality and landing page engagement.

Organic search traffic provides stable performance,
suggesting strong alignment between user intent and
site content.

Social traffic generates the lowest-quality visitors.
While nearly half of cart users eventually purchase,
very few visitors reach the cart stage in the first
place.

============================================================
RECOMMENDATIONS
============================================================

1. Increase investment in email marketing campaigns,
   as it delivers the highest conversion efficiency.

2. Expand audience segmentation and personalization
   within email campaigns to maximize ROI.

3. Review paid advertising creatives, audience
   targeting, and landing pages to improve
   View-to-Cart conversion rates.

4. Strengthen SEO efforts to increase high-intent
   organic traffic.

5. Reassess social media targeting, messaging,
   and campaign objectives to improve visitor
   quality and engagement.

============================================================
*/