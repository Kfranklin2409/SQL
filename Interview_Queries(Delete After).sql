USE mavenfuzzyfactory;

-- Analyzing Cross-selling Performance for 2nd product being added to the '/cart' page. 

SELECT
	CASE
		WHEN website_pageviews.created_at < '2013-09-25' THEN 'A.Pre_Cross_Sell'
		WHEN website_pageviews.created_at >= '2013-09-25' THEN 'B.Post_Cross_Sell'
		ELSE 'logic_error'
END AS time_period
    ,COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url ='/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS cart_sessions
    ,COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url ='/shipping' THEN website_pageviews.website_session_id ELSE NULL END) AS clicktroughs
    ,COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url ='/shipping' THEN website_pageviews.website_session_id ELSE NULL END)
		/ COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url ='/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS cart_crt
    ,sum(orders.items_purchased)/COUNT(orders.order_id) AS products_per_order
    ,AVG(orders.price_usd) AS AOV
    ,SUM(CASE WHEN website_pageviews.pageview_url ='/cart' THEN orders.price_usd  ELSE NULL END)
		/COUNT(DISTINCT CASE WHEN website_pageviews.pageview_url ='/cart' THEN website_pageviews.website_session_id ELSE NULL END) AS rev_per_cart_sessions
FROM website_pageviews
	LEFT JOIN orders
		ON website_pageviews.website_session_id = orders.website_session_id
WHERE
	website_pageviews.created_at > '2013-08-25'
		AND website_pageviews.created_at < '2013-10-25'
GROUP BY 1;

-- Pre and post analysis of product launch on Dec. 12th, 2013

SELECT
	CASE 
		WHEN ws.created_at < '2013-12-12' THEN 'A. Pre_Birthday_Bear'
        WHEN ws.created_at >= '2013-12-12' THEN 'B. Post_Birthday_Bear'
        ELSE 'Check logic'
	END AS time_period,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders, 
    ROUND(COUNT(DISTINCT o.order_id) / COUNT(DISTINCT ws.website_session_id) * 100, 2) as conv_rt,
    SUM(o.price_usd) AS total_revenue,
    SUM(o.items_purchased) AS total_products_sold,
    SUM(o.price_usd) / COUNT(DISTINCT o.order_id) AS avg_order_value,
    AVG(o.price_usd) AS AOV, 
    SUM(o.items_purchased) /  COUNT(DISTINCT o.order_id) AS products_per_order,
	SUM(o.price_usd) / COUNT(DISTINCT ws.website_session_id) AS revenue_per_session
FROM website_sessions ws
	LEFT JOIN orders o
		ON o.website_session_id = ws.website_session_id
WHERE ws.created_at BETWEEN '2013-11-12' AND '2014-01-12' -- month before and after product launch
GROUP BY 1; 
