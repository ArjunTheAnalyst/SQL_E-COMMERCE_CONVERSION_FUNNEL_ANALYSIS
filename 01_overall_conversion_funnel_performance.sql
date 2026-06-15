/* ============================================================
   SECTION 1: OVERALL CONVERSION FUNNEL PERFORMANCE

   Objective:
   Analyze how users progress through the e-commerce funnel
   over the most recent 30-day period.

   Funnel Stages:
   1. Page View
   2. Add to Cart
   3. Checkout Start
   4. Payment Information
   5. Purchase

   Metrics Calculated:
   • Users at each stage
   • Conversion from previous stage
   • Overall conversion from first stage
   • Drop-off percentage
============================================================ */

WITH funnel_stage_counts AS
(SELECT
	COUNT(DISTINCT CASE 
		WHEN event_type LIKE 'page_view' 
		THEN [user_id] 
		ELSE NULL END) AS page_view_users,
	
	COUNT(DISTINCT CASE 
		WHEN event_type LIKE 'add_to_cart' 
		THEN [user_id] 
		ELSE NULL END) AS add_to_cart_users,
	
	COUNT(DISTINCT CASE 
		WHEN event_type LIKE 'checkout_start' 
		THEN [user_id] 
		ELSE NULL END) AS checkout_users,
	
	COUNT(DISTINCT CASE 
		WHEN event_type LIKE 'payment_info' 
		THEN [user_id] 
		ELSE NULL END) AS payment_users,
	
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
),

/* ------------------------------------------------------------
   Convert wide-format funnel metrics into a vertical structure
   for easier stage-by-stage analysis.
------------------------------------------------------------ */

funnel_stage_breakdown AS
(
SELECT
	1 AS funnel_stage_order,
	'Page View' AS funnel_stage,
	page_view_users AS stage_users
FROM
	funnel_stage_counts

UNION ALL

SELECT
	2 AS funnel_stage_order,
	'Add to Cart' AS funnel_stage,
	add_to_cart_users AS stage_users
FROM
	funnel_stage_counts

UNION ALL

SELECT
	3 AS funnel_stage_order,
	'Checkout Start' AS funnel_stage,
	checkout_users AS stage_users
FROM
	funnel_stage_counts

UNION ALL

SELECT
	4 AS funnel_stage_order,
	'Payment Information' AS funnel_stage,
	payment_users AS stage_users
FROM
	funnel_stage_counts

UNION ALL

SELECT
	5 AS funnel_stage_order,
	'Purchase' AS funnel_stage,
	purchase_users AS stage_users
FROM
	funnel_stage_counts
)

SELECT
	funnel_stage_order,
	funnel_stage,
	stage_users,

	/* --------------------------------------------------------
       Stage-to-Stage Conversion Rate

       Example:
       Checkout Users ÷ Add-to-Cart Users
    -------------------------------------------------------- */

	ROUND(
	(
	stage_users
	/
	CAST(
	LAG(stage_users) 
	OVER(ORDER BY funnel_stage_order) AS FLOAT)
	) * 100, 2) AS conversion_from_previous_stage_pct,

	 /* --------------------------------------------------------
       Overall Funnel Conversion

       Example:
       Purchase Users ÷ Page View Users
    -------------------------------------------------------- */

	ROUND(
	(
	stage_users
	/
	CAST(
	FIRST_VALUE(stage_users)
	OVER(ORDER BY funnel_stage_order ROWS UNBOUNDED PRECEDING) AS FLOAT)
	) * 100, 2) AS overall_funnel_conversion_pct,

	/* --------------------------------------------------------
       Percentage of users lost between stages

       Example:
       (Current Stage Users - Previous Stage Users)
       ÷ Previous Stage Users
    -------------------------------------------------------- */

	ROUND(
	(
	(
	stage_users
	-
	LAG(stage_users)
	OVER(ORDER BY funnel_stage_order)
	)
	/
	CAST(
	LAG(stage_users)
	OVER(ORDER BY funnel_stage_order) AS FLOAT)
	) * 100, 2) AS drop_off_percentage
FROM
	funnel_stage_breakdown;


/*
============================================================
FUNNEL PERFORMANCE SUMMARY
============================================================

| Stage               | Users | Conversion from Previous | Overall Conversion | Drop-Off  |
|---------------------|-------|--------------------------|------------------- |---------- |
| Page View           | 4,291 | N/A                      | 100.00%            | N/A       |
| Add to Cart         | 1,338 | 31.18%                   | 31.18%             | -68.82%   |
| Checkout Start      |   954 | 71.30%                   | 22.23%             | -28.70%   |
| Payment Information |   770 | 80.71%                   | 17.94%             | -19.29%   |
| Purchase            |   709 | 92.08%                   | 16.52%             | -7.92%    |

============================================================
KEY FINDINGS
============================================================
1. The largest funnel leakage occurs between
   Page View and Add to Cart.
	
	• Only 31.18% of visitors add an item to cart.
	• 68.82% of users exit at this stage.
	• This is the single biggest conversion bottleneck.

2. User intent strengthens significantly after
   a product is added to the cart.

	• Cart -> Checkout conversion: 71.30%
	• Checkout -> Payment conversion: 80.71%
	• Payment -> Purchase conversion: 92.08%

3. Drop-off steadily decreases throughout
   the funnel.

	• Add to Cart: 68.82%
	• Checkout Start: 28.70%
	• Payment Information: 19.29%
	• Purchase Stage: 7.92%

4. The overall visitor-to-purchase conversion
   rate is 16.52%.

   • 709 of 4,291 visitors completed a purchase.

============================================================
BUSINESS INTERPRETATION
============================================================

The primary opportunity for improvement lies at
the top of the funnel. While traffic volume is
healthy, a substantial proportion of visitors do
not progress to the Add-to-Cart stage.

Once users demonstrate purchase intent by adding
an item to their cart, the funnel performs
efficiently, with strong progression through
checkout, payment, and final purchase stages.

============================================================
RECOMMENDATIONS
============================================================
1. Investigate the 68.82% Page View -> Add to Cart
   drop-off through product page analysis.

2. Review pricing strategy, product messaging,
   and call-to-action placement.

3. Conduct A/B testing on product pages to
   improve visitor engagement and cart additions.

4. Deploy retargeting campaigns for visitors who
   leave before adding products to their cart.

5. Maintain the current checkout and payment
   experience, as these stages demonstrate
   strong conversion efficiency.

============================================================
*/