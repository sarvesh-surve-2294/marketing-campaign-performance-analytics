-- ==========================================================
-- 05. Business Performance Analysis
-- ==========================================================

USE marketing_campaign_analysis;

-- ==========================================================
-- 1. Overall Business KPIs
-- ==========================================================

SELECT
    ROUND(SUM(spend),2) AS total_spend,
    ROUND(SUM(revenue),2) AS total_revenue,
    ROUND(SUM(revenue)-SUM(spend),2) AS total_profit,
    ROUND(((SUM(revenue)-SUM(spend))/SUM(spend))*100,2) AS roi,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas
FROM marketing_campaigns;

-- Business Insight:
-- • Provides an executive summary of the complete marketing performance.
-- • Helps understand overall profitability and return on investment.

-- ==========================================================
-- 2. Revenue by Marketing Objective
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(revenue),2) AS revenue
FROM marketing_campaigns
GROUP BY objective
ORDER BY revenue DESC;

-- Business Insight:
-- • Identifies which marketing objective contributes the highest revenue.
-- • Useful for future budget allocation.

-- ==========================================================
-- 3. Spend by Marketing Objective
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(spend),2) AS spend
FROM marketing_campaigns
GROUP BY objective
ORDER BY spend DESC;

-- Business Insight:
-- • Shows where the marketing budget is being invested.
-- • Compare spend against revenue to evaluate efficiency.

-- ==========================================================
-- 4. Objective-wise ROAS
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(spend),2) AS spend,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas
FROM marketing_campaigns
GROUP BY objective
HAVING SUM(spend)>0
ORDER BY roas DESC;

-- Business Insight:
-- • Higher ROAS indicates better return for every ₹1 invested.
-- • Helps identify the most efficient marketing objective.

-- ==========================================================
-- 5. Objective-wise ROI
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(spend),2) AS spend,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(((SUM(revenue)-SUM(spend))/SUM(spend))*100,2) AS roi
FROM marketing_campaigns
GROUP BY objective
HAVING SUM(spend)>0
ORDER BY roi DESC;

-- Business Insight:
-- • Measures actual profitability after deducting marketing cost.
-- • Useful for long-term strategic decisions.

-- ==========================================================
-- 6. Most Profitable Objective
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(revenue)-SUM(spend),2) AS profit
FROM marketing_campaigns
GROUP BY objective
ORDER BY profit DESC;

-- Business Insight:
-- • Reveals which business objective generates the highest net profit.
-- • Profit is a better KPI than revenue alone.

-- ==========================================================
-- 7. Highest Conversion Rate by Objective
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(conversions)*100.0/SUM(clicks),2) AS conversion_rate
FROM marketing_campaigns
GROUP BY objective
HAVING SUM(clicks)>0
ORDER BY conversion_rate DESC;

-- Business Insight:
-- • Shows which campaign objective converts users most efficiently.
-- • Useful for lead generation and sales optimization.

-- ==========================================================
-- 8. Objective Performance Category
-- ==========================================================

SELECT
    objective,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas,

    CASE
        WHEN SUM(revenue)/SUM(spend)>=5 THEN 'Excellent'
        WHEN SUM(revenue)/SUM(spend)>=3 THEN 'Good'
        WHEN SUM(revenue)/SUM(spend)>=2 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance

FROM marketing_campaigns
GROUP BY objective
HAVING SUM(spend)>0
ORDER BY roas DESC;

-- Business Insight:
-- • Categorizes each objective into performance bands.
-- • Helps business stakeholders quickly identify weak objectives.

-- ==========================================================
-- 9. Top 10 Most Profitable Campaigns
-- ==========================================================

SELECT
    campaign_name,
    platform,
    objective,
    ROUND(SUM(revenue)-SUM(spend),2) AS profit,
    ROUND(((SUM(revenue)-SUM(spend))/SUM(spend))*100,2) AS roi
FROM marketing_campaigns
GROUP BY campaign_name,platform,objective
HAVING SUM(spend)>0
ORDER BY profit DESC
LIMIT 10;

-- Business Insight:
-- • Identifies campaigns contributing the highest profit.
-- • Useful for replication and future campaign planning.

-- ==========================================================
-- 10. Top 10 Loss-Making Campaigns
-- ==========================================================

SELECT
    campaign_name,
    platform,
    objective,
    ROUND(SUM(revenue)-SUM(spend),2) AS profit
FROM marketing_campaigns
GROUP BY campaign_name,platform,objective
ORDER BY profit
LIMIT 10;

-- Business Insight:
-- • Finds campaigns with the biggest financial losses.
-- • Useful for optimization or discontinuation.

-- ==========================================================
-- 11. Revenue Contribution by Objective
-- ==========================================================

SELECT
    objective,

    ROUND(SUM(revenue),2) AS revenue,

    ROUND(
        SUM(revenue)*100/
        (SELECT SUM(revenue) FROM marketing_campaigns),
    2) AS revenue_percentage

FROM marketing_campaigns
GROUP BY objective
ORDER BY revenue DESC;

-- Business Insight:
-- • Shows percentage contribution of each objective.
-- • Helps prioritize revenue-driving marketing goals.

-- ==========================================================
-- 12. Spend Contribution by Objective
-- ==========================================================

SELECT
    objective,

    ROUND(SUM(spend),2) AS spend,

    ROUND(
        SUM(spend)*100/
        (SELECT SUM(spend) FROM marketing_campaigns),
    2) AS spend_percentage

FROM marketing_campaigns
GROUP BY objective
ORDER BY spend DESC;

-- Business Insight:
-- • Indicates how the total marketing budget is distributed.
-- • Compare with revenue contribution for efficiency.

-- ==========================================================
-- 13. Platform + Objective Performance Matrix
-- ==========================================================

SELECT
    platform,
    objective,
    ROUND(SUM(spend),2) AS spend,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas
FROM marketing_campaigns
GROUP BY platform,objective
HAVING SUM(spend)>0
ORDER BY objective,revenue DESC;

-- Business Insight:
-- • Compare platform performance within each marketing objective.
-- • Helps identify the strongest platform for every objective.

-- ==========================================================
-- 14. Best Platform for Every Objective
-- ==========================================================

SELECT
    objective,
    platform,
    revenue
FROM
(
    SELECT
        objective,
        platform,
        ROUND(SUM(revenue),2) AS revenue,

        ROW_NUMBER() OVER(
            PARTITION BY objective
            ORDER BY SUM(revenue) DESC
        ) AS rn

    FROM marketing_campaigns
    GROUP BY objective,platform
) ranked_platforms

WHERE rn=1
ORDER BY objective;

-- Business Insight:
-- • Returns the highest revenue-generating platform for every objective.
-- • Useful while deciding channel strategy.

-- ==========================================================
-- 15. Business Summary Dashboard
-- ==========================================================

SELECT
    objective,

    COUNT(DISTINCT campaign_id) AS campaigns,

    ROUND(SUM(spend),2) AS spend,

    ROUND(SUM(revenue),2) AS revenue,

    ROUND(SUM(revenue)-SUM(spend),2) AS profit,

    ROUND(((SUM(revenue)-SUM(spend))/SUM(spend))*100,2) AS roi,

    ROUND(SUM(revenue)/SUM(spend),2) AS roas

FROM marketing_campaigns

GROUP BY objective

HAVING SUM(spend)>0

ORDER BY revenue DESC;

-- Business Insight:
-- • Executive summary combining campaigns, spend, revenue, profit, ROI and ROAS.
-- • Can directly power a business dashboard or management report.