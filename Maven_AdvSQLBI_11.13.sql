USE mavenfuzzyfactory;

-- created_at <= '2012-11-27'

-- Q1
SELECT 
	MIN(DATE(ws.created_at)) AS Monthly_gsearch_trend, 
    COUNT(DISTINCT ws.website_session_id) AS gsearch_sessions, 
    COUNT(DISTINCT o.order_id) AS Orders
FROM website_sessions ws
	LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE utm_source = 'gsearch' 
	AND ws.created_at <= '2012-11-27'
GROUP BY MONTH(DATE(ws.created_at))
;

-- Q2 
SELECT 
	MIN(DATE(ws.created_at)) AS Monthly_gsearch_trend, 
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN ws.website_session_id ELSE null END) AS gsearch_brand_sessions, 
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN o.order_id ELSE null END) AS brand_campaign_orders,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN ws.website_session_id ELSE null END) AS gsearch_nonbrand_sessions,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN o.order_id ELSE null END) AS nonbrand_campaign_orders
FROM website_sessions ws
	LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE utm_source = 'gsearch' 
	AND ws.created_at <= '2012-11-27'
GROUP BY MONTH(DATE(ws.created_at))
;

-- Q3
SELECT 
	MIN(DATE(ws.created_at)) AS Monthly_gsearch_nonbrand_trend, 
    device_type,
    COUNT(DISTINCT ws.website_session_id) AS gsearch_nonbrand_sessions,
    COUNT(DISTINCT o.order_id) AS Orders
FROM website_sessions ws
LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE utm_source = 'gsearch' 
	AND utm_campaign = 'nonbrand'
	AND ws.created_at <= '2012-11-27'
GROUP BY MONTH(DATE(ws.created_at)),2
-- ORDER BY 2
;

-- Q4
SELECT 
	MIN(DATE(ws.created_at)) AS Monthly_utm_source_trend, 
    utm_source,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS Orders
FROM website_sessions ws
LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE utm_source <> 'null'
	AND ws.created_at <= '2012-11-27'
GROUP BY MONTH(DATE(ws.created_at)),2
ORDER BY 1, 2 desc
;

-- Q5
SELECT 
	MIN(DATE(ws.created_at)) AS Month, 
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS Orders, 
    (COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id)) * 100 AS monthly_cvr
FROM website_sessions ws
LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at <= '2012-11-1'
GROUP BY MONTH(DATE(ws.created_at));

-- Q6 
SELECT 
	COUNT(DISTINCT o.order_id) AS Orders,
    SUM(price_usd)
FROM orders o
LEFT JOIN website_sessions ws
	ON ws.website_session_id = o.website_session_id
WHERE ws.created_at >= '2012-07-28'
	AND ws.created_at <= '2012-11-27'
	AND utm_campaign = 'nonbrand'
;

SELECT 
	MIN(DATE(ws.created_at)) AS MONTH,
    -- utm_campaign,
	COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS Orders, 
    (COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id)) * 100 AS monthly_cvr,
    SUM(price_usd) AS Revenue
FROM website_sessions ws
LEFT JOIN orders o
		ON ws.website_session_id = o.website_session_id
WHERE ws.created_at >= '2012-07-28'
	AND ws.created_at <= '2012-11-27'
	AND utm_campaign = 'nonbrand'
GROUP BY MONTH(DATE(ws.created_at))
;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Conversion Funnels Excercise
/*
SELECT 
	website_session_id,
    pageview_url,
    created_at,
    MIN(website_pageview_id)
FROM website_pageviews
WHERE pageview_url = '/billing-2'
GROUP BY 1,2,3
ORDER BY 3
;

CREATE TEMPORARY TABLE billing_pages_and_orders1 
SELECT
	website_session_id,
    MAX(billing_1_seen) AS billing1,
    MAX(billing_2_seen) AS billing2,
    MAX(order_made) AS ordered
FROM (

SELECT 
	ws.website_session_id,
    wp.pageview_url, 
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_1_seen,
    CASE WHEN pageview_url = '/billing-2' THEN 1 ELSE 0 END AS billing_2_seen,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS order_made
FROM website_sessions ws
	LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at < '2012-11-10' 
	AND wp.website_pageview_id >= 53550
	AND wp.pageview_url IN ('/billing-2','/billing','/thank-you-for-your-order')
) AS pages_viewed_level
GROUP BY 1
;

CREATE TEMPORARY TABLE OG_billing_ordered_sessions1
SELECT 
	bpo.website_session_id,
    billing1,
    ordered
FROM billing_pages_and_orders1 bpo
	LEFT JOIN orders o 
		ON bpo.website_session_id = o.website_session_id
WHERE billing1 = '1'   
;

CREATE TEMPORARY TABLE New_billing_ordered_sessions1
SELECT 
	bpo.website_session_id,
    billing2,
    ordered
FROM billing_pages_and_orders1 bpo
	LEFT JOIN orders o 
		ON bpo.website_session_id = o.website_session_id
WHERE billing2 = '1'
;

SELECT
	(COUNT(DISTINCT CASE WHEN obos.ordered = '1' AND obos.billing1 = '1' THEN obos.website_session_id ELSE null END) 
		/ COUNT(obos.website_session_id)) * 100 AS OG_billing_orders_Conv_rt,
	(COUNT(DISTINCT CASE WHEN nbos.ordered = '1' AND nbos.billing2 = '1'THEN nbos.website_session_id ELSE null END) 
		/ COUNT(nbos.website_session_id)) * 100 AS New_billing_orders_Conv_rt
FROM billing_pages_and_orders1 bpo
	 LEFT JOIN OG_billing_ordered_sessions1 obos
		ON obos.website_session_id = bpo.website_session_id
	LEFT JOIN New_billing_ordered_sessions1 nbos
		ON nbos.website_session_id = bpo.website_session_id
;


CREATE TEMPORARY TABLE billing_pages_sessions
SELECT 
	ws.website_session_id,
    wp.pageview_url
FROM website_sessions ws
	LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at < '2012-11-10' 
	AND wp.website_pageview_id >= 53550
	AND wp.pageview_url IN ('/billing-2','/billing')
;

CREATE TEMPORARY TABLE Ordered_sessions
SELECT 
	website_session_id,
    pageview_url,
    MAX(ordered) AS Created_order
FROM ( 
SELECT 
	bps.website_session_id,
    bps.pageview_url,
    CASE WHEN wp.pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS ordered
FROM billing_pages_sessions bps
	LEFT JOIN website_pageviews wp 
		ON bps.website_session_id = wp.website_session_id
GROUP BY 1,2,3 ) AS  ordered_sessions
-- WHERE ordered = '1'
GROUP BY 1,2
ORDER BY 1
;

SELECT 
	bps.pageview_url AS billing_version_seen,
	COUNT(bps.website_session_id) AS sessions,
	COUNT(os.website_session_id) AS orders, 
    (COUNT(os.website_session_id) / COUNT(bps.website_session_id)) * 100 AS billing_to_order_rt
FROM billing_pages_sessions bps
	LEFT JOIN ordered_sessions os
		ON os.website_session_id = bps.website_session_id
GROUP BY 1
;

-- How instructor solved
SELECT 
	wp.website_session_id,
    wp.pageview_url AS billing_version_seen,
    o.order_id
FROM website_pageviews wp
	LEFT JOIN orders o
		ON o.website_session_id = wp.website_session_id
WHERE wp.created_at < '2012-11-10' 
	AND wp.website_pageview_id >= 53550
	AND wp.pageview_url IN ('/billing-2','/billing')
;

SELECT 
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    (COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id)) * 100 AS billing_to_order_rt
FROM ( 
SELECT 
	wp.website_session_id,
    wp.pageview_url AS billing_version_seen,
    o.order_id
FROM website_pageviews wp
	LEFT JOIN orders o
		ON o.website_session_id = wp.website_session_id
WHERE wp.created_at < '2012-11-10' 
	AND wp.website_pageview_id >= 53550
	AND wp.pageview_url IN ('/billing-2','/billing')
) AS billing_sessions_w_orders
GROUP BY 1
;

CREATE TEMPORARY TABLE session_level_flags2
SELECT
	website_session_id,
    MAX(products_ct) AS products_made_it,
    MAX(mrfuzzy_ct) AS mrfuzzy_made_it,
    MAX(cart_ct) AS cart_made_it,
    MAX(shipping_ct) AS shipping_made_it,
    MAX(thankyou_ct) AS thankyou_made_it
FROM (

SELECT 
	ws.website_session_id,
    wp.pageview_url,
    wp.created_at, 
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_ct, 
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_ct, 
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_ct, 
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_ct, 
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_ct    
FROM website_sessions ws
	LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at BETWEEN '2012-08-05' AND '2012-09-05'
	AND pageview_url <> '/home'
    AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
ORDER BY 1,3
) AS page_level_views
GROUP BY 1;

SELECT 
	COUNT(website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE null END) AS click_to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE null END) AS click_to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE null END) AS click_to_cart,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE null END) AS click_to_shipping,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE null END) AS click_to_thankyou
FROM session_level_flags1

UNION ALL

SELECT 
	COUNT(website_session_id) AS sessions,
    (COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE null END)/ COUNT(website_session_id)) * 100 AS lander_clickthrough_rate, 
	(COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE null END) / COUNT(DISTINCT CASE WHEN products_made_it = 1 THEN website_session_id ELSE null END)) * 100 AS products_clickthrough_rate,
	(COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE null END)  / COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE null END)) * 100 AS mrfuzzy_clickthrough_rate,
	(COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE null END) / COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE null END)) * 100 AS cart_clickthrough_rate,
	(COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE null END) / COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE null END)) * 100 AS shipping_clickthrough_rate
FROM session_level_flags2;

-- Building Conversion Funnels

-- BUSINESS CONTEXT
	-- We want to build a mini conversion funnel, from /lander-2 to /cart
    -- We want to know how many people reach each step, and also dropoff rates
    -- for simplicity of the demo, we're looking at /lander-2 traffic only
    -- for simplicity, we're looking at customers who like Mr. Fuzzy only

-- STEP 1: select all pageviews for relevant sessions
-- STEP 2: identify each relevant pageview as the specific funnel step
-- STEP 3: create the session-level conversion funnel view
-- STEP 4: aggregate the data to assess funnel performance

SELECT 
	ws.website_session_id,
    wp.pageview_url,
    wp.created_at AS pageview_created_at
    , CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    , CASE WHEN pageview_url = '/the-original-mr-fuzzy'THEN 1 ELSE 0 END AS mrfuzzy_page
    , CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions ws
	LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- RANDOM TIMEFRAME FOR DEMO
	AND wp.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY 1,3
;

CREATE TEMPORARY TABLE session_level_flags
SELECT 
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it
FROM ( 

SELECT 
	ws.website_session_id,
    wp.pageview_url,
    wp.created_at AS pageview_created_at
    , CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    , CASE WHEN pageview_url = '/the-original-mr-fuzzy'THEN 1 ELSE 0 END AS mrfuzzy_page
    , CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions ws
	LEFT JOIN website_pageviews wp
		ON ws.website_session_id = wp.website_session_id
WHERE ws.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- RANDOM TIMEFRAME FOR DEMO
	AND wp.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY 1,3
) AS pageview_level
GROUP BY 1;

SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
    
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS Clicked_to_products,
	(COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)
		/ COUNT(DISTINCT website_session_id)) * 100 AS lander_clickedthrough_rate,
        
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS Clicked_to_mrfuzzy,
    (COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)
		/ COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)) * 100 AS products_clickedthrough_rate,
        
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS clicked_to_cart,
    (COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)
		/ COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)) * 100 AS mrfuzzy_clickedthrough_rate
        
FROM session_level_flags
;
*/
---------------------------------------------------------------------------------------------------
-- TEMPORARY TABLES
/*
-- STEP 1: finding the first website_pageview_id for the relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session m, to identify "bounces"
-- STEP 4: sumarizing by week (bounce rate, session to each lander)

CREATE TEMPORARY TABLE first_pv
SELECT 
	DATE(wp.created_at) AS Date,
    WP.website_session_ID AS session_id,
    MIN(wp.website_pageview_id) AS min_pv
FROM website_pageviews wp
	INNER JOIN website_sessions ws
		ON ws.website_session_id = wp.website_session_id
		AND ws.created_at BETWEEN '2012-06-01' AND '2012-08-31'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1,2	;

CREATE TEMPORARY TABLE landing_pg
SELECT  
	Date,
    fp.session_id,
    wp.pageview_url
FROM first_pv fp
LEFT JOIN website_pageviews wp
	ON fp.min_pv = wp.website_pageview_id
WHERE pageview_url IN ('/home','/lander-1')		;

CREATE TEMPORARY TABLE bounced_list
SELECT 
	lp.session_id,
    lp.pageview_url,
    COUNT(wp.website_session_id) AS pages_viewed
FROM landing_pg lp
	LEFT JOIN website_pageviews wp
		ON lp.session_id = wp.website_session_id
 GROUP BY 1,2 
 HAVING pages_viewed = 1		;

SELECT 
	MIN(Date) AS week_start_date,
    (COUNT(DISTINCT bl.session_id) / COUNT(DISTINCT lp.session_id)) * 100 AS bounce_rt,
	COUNT(DISTINCT CASE WHEN lp.pageview_url = '/home' 
		THEN lp.session_id
			ELSE NULL 
				END) AS home_sessions,
	COUNT(DISTINCT CASE WHEN lp.pageview_url = '/lander-1' 
		THEN lp.session_id
			ELSE NULL 
				END) AS lander_sessions
FROM landing_pg lp
	LEFT JOIN bounced_list bl
		ON lp.session_id = bl.session_id
GROUP BY WEEK(Date)		;


-- Creating Temporary Tables 
-- BUSINESS CONTEXT: We want to see landing page performance for a certain time period

-- finding the minimum website pageview id associated with each session we care about

-- Create a temp table
CREATE TEMPORARY TABLE first_pageviews_demo 
SELECT 
	website_pageviews.website_session_id,
	MIN(website_pageviews.website_pageview_id) AS min_pv_id
FROM website_pageviews
	INNER JOIN website_sessions
	ON website_sessions.website_session_id = website_pageviews.website_session_id
    AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1
;

SELECT * FROM first_pageviews_demo;

CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT
	first_pageviews_demo.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews_demo
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviews_demo.min_pv_id -- website pagview is the landing page view
; 

SELECT * FROM sessions_w_landing_page_demo;

CREATE TEMPORARY TABLE bounced_sessions_only
SELECT 
	sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_landing_page_demo
	LEFT JOIN website_pageviews
		ON sessions_w_landing_page_demo.website_session_id = website_pageviews.website_session_id
GROUP BY 1,2
HAVING 
	COUNT(3) = 1
    ;

SELECT 
	sessions_w_landing_page_demo.landing_page,
    COUNT(sessions_w_landing_page_demo.website_session_id) AS Total_sessions,
	COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_sessions,
    (COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(sessions_w_landing_page_demo.website_session_id)) * 100 AS Bounce_rt
FROM sessions_w_landing_page_demo
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY 1
ORDER BY 4 DESC	
;

-- STEP 1: finding the firt website_pageview_id ofr relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session, to identify "bounces"
-- STEP 4: summarizing by counting total sessions and bounced sessions

CREATE TEMPORARY TABLE first_pv
SELECT 
	websesh.Website_session_id AS sessions,
    MIN(pv.website_pageview_id) AS landing_pv_id
FROM website_sessions websesh
LEFT JOIN website_pageviews pv
	ON websesh.website_session_id = pv.website_session_id
WHERE websesh.created_at < '2012-06-14'
GROUP BY 1		;

CREATE TEMPORARY TABLE landing_page
SELECT 	
	first_pv.sessions,
    pv.pageview_url AS landing_page
FROM first_pv
LEFT JOIN website_pageviews pv
	ON first_pv.landing_pv_id = pv.website_pageview_id	;

CREATE TEMPORARY TABLE bounced_sessions
SELECT 
	landing_page.sessions,
    landing_page.landing_page,
    COUNT(pv.website_session_id) AS pages_seen
FROM landing_page
LEFT JOIN website_pageviews pv
	ON landing_page.sessions = pv.website_session_id
GROUP BY 1,2
HAVING COUNT(pv.website_session_id) = 1		;

SELECT 
	COUNT(A.sessions) AS Total_sessions,
    COUNT(bs.sessions) AS bounced_sessions,
    (COUNT(bs.sessions) / COUNT(A.sessions)) * 100 AS bs_rate
FROM landing_page A 
	LEFT JOIN bounced_sessions bs
		ON A.sessions = bs.sessions
;

CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
;

CREATE TEMPORARY TABLE first_pageviews
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id -- Will give lowest pageview_id or first page seen by that session ID
FROM website_pageviews
GROUP BY 1 -- WILL ONLY HAVE 1 SESSION ID
;

SELECT 
	website_pageviews.pageview_url,
    COUNT(website_pageview_id) AS sessions_landing_on_page
FROM website_pageviews
JOIN first_pageviews
	ON first_pageviews.min_pv_id = website_pageviews.website_pageview_id
WHERE created_at < '2012-06-12'
GROUP BY 1
;

-- STEP 1: find the first pageview for each session
-- STEP 2: find the url the customer saw on that 1st page

CREATE TEMPORARY TABLE First_pv_per_session
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS first_pv
FROM website_pageviews
WHERE created_at < '2012-06-12'
GROUP BY 1
;

SELECT 
	website_pageviews.pageview_url AS Landing_page_url,
    COUNT(DISTINCT first_pv_per_session.website_session_id) AS sessions_hitting_page
FROM first_pv_per_session
	LEFT JOIN website_pageviews
		ON first_pv_per_session.first_pv = website_pageviews.website_pageview_id
GROUP BY 1
;

SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
JOIN first_pageview
	ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY 1,2
;

 SELECT 
	pageview_url,
    COUNT(DISTINCT website_PAGEVIEW_id) AS PVS
FROM website_pageviews
WHERE created_at < '2012-06-09'
GROUP BY 1
ORDER BY 2 DESC
;

CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM website_pageviews
WHERE website_session_id < 1000
GROUP BY website_session_id;

SELECT * FROM first_pageview 
;

SELECT 
	pageview_url,
    COUNT(DISTINCT website_pageview_id) AS pvs
FROM website_pageviews
WHERE website_pageview_id <1000
GROUP BY  pageview_url
ORDER BY pvs DESC
;

*/
---------------------------------------------------------------------------------------------------
-- Dates
/*  
SELECT 
	MIN(DATE(created_at)) AS Week_start_date,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' 
		THEN website_session_id 
			ELSE NULL 
				END) AS dtop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' 
		THEN website_session_id 
			ELSE NULL 
				END) AS mob_sessions    
FROM Website_sessions
WHERE created_at < '2012-06-09'  
	AND created_at > '2012-04-15'
    AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
GROUP BY  WEEK(created_at)
;

-- STEP 0: find out when thenew page /lander launched
-- STEP 1: finding the first website_pageview_id for relevant sessions
-- STEP 2: identifying the landing page of each session
-- STEP 3: counting pageviews for each session, to identify "bounces"
-- STEP 4: summarizing total sessions and bounced sessions, by LP

SELECT 
	MIN(created_at),
    MIN(website_pageview_id),
    pageview_url
FROM website_pageviews
WHERE pageview_url = '/lander-1'
GROUP BY 3
; -- Same Result[Check] 

CREATE TEMPORARY TABLE first_test_pageviews
SELECT 
	wp.website_session_id,
    MIN(wp.website_pageview_id) AS min_pageview_id
FROM website_pageviews wp
	INNER JOIN website_sessions ws -- inner join bc we only want results that are the same. Not all from wp
		ON ws.website_session_id = wp.website_session_id
        AND ws.created_at < '2012-07-28' -- prescribed by assignment
        AND wp.website_pageview_id > 23504 -- the min_pageview_id we found for /lander
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1 
;

-- connecting session_id & pageview_id to pageview_url in website_pageview table with only /home and /lander-1 as the url
CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT 
	fp.website_session_id,
    wp.pageview_url AS landing_page
FROM first_test_pageviews fp
	LEFT JOIN website_pageviews wp
		ON wp.website_pageview_id = fp.min_pageview_id
WHERE wp.pageview_url IN ('/home', '/lander-1')
;

-- finding count of pageviews limited to 1

CREATE TEMPORARY TABLE nonbrand_test_bs_list
 SELECT  
	nts.website_session_id,
    nts.landing_page,
    COUNT(wp.website_session_id) AS page_count
FROM nonbrand_test_sessions_w_landing_page nts
LEFT JOIN website_pageviews wp
	ON nts.website_session_id = wp.website_session_id
GROUP BY 1,2
HAVING page_count = 1
;

-- Using the 3 temp tables to find total sessions, bounced sessions, and bounce rate by landing page
SELECT
	nts.landing_page,
    COUNT(DISTINCT nts.website_session_id) AS total_sessions,
    COUNT(DISTINCT ntb.website_session_id) AS total_bs,
    (COUNT(ntb.website_session_id) / COUNT(nts.website_session_id)) * 100 AS bounce_rt
FROM nonbrand_test_sessions_w_landing_page nts
	LEFT JOIN nonbrand_test_bs_list ntb
		ON nts.website_session_id = ntb.website_session_id
GROUP BY 1
;

*/ 