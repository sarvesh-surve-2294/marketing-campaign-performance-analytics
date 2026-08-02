-- ==========================================================
-- Platform Performance Analysis
-- ==========================================================


SELECT
    platform,
    ROUND(SUM(spend),2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue),2) AS total_revenue
FROM marketing_campaigns
GROUP BY platform
ORDER BY total_revenue DESC;



SELECT
    platform,

    ROUND(
        SUM(clicks)*100.0/SUM(impressions),
        2
    ) AS ctr,

    ROUND(
        SUM(conversions)*100.0/SUM(clicks),
        2
    ) AS conversion_rate,

    ROUND(
        SUM(spend)/SUM(clicks),
        2
    ) AS cpc,

    ROUND(
        SUM(spend)*1000/SUM(impressions),
        2
    ) AS cpm,

    ROUND(
        SUM(spend)/SUM(conversions),
        2
    ) AS cpa,

    ROUND(
        SUM(revenue)/SUM(spend),
        2
    ) AS roas

FROM marketing_campaigns

GROUP BY platform
ORDER BY roas DESC;



SELECT
    platform,

    ROUND(SUM(revenue),2) AS revenue,

    ROUND(
        SUM(revenue) * 100 /
        (SELECT SUM(revenue) FROM marketing_campaigns),
        2
    ) AS revenue_percentage

FROM marketing_campaigns

GROUP BY platform

ORDER BY revenue DESC;



SELECT
    platform,

    ROUND(SUM(spend),2) AS spend,

    ROUND(
        SUM(spend)*100/
        (SELECT SUM(spend) FROM marketing_campaigns),
        2
    ) AS spend_percentage

FROM marketing_campaigns

GROUP BY platform

ORDER BY spend DESC;



SELECT
    platform,

    ROUND(SUM(spend),2) AS spend,

    ROUND(SUM(revenue),2) AS revenue,

    ROUND(
        ((SUM(revenue)-SUM(spend))/SUM(spend))*100,
        2
    ) AS roi

FROM marketing_campaigns

GROUP BY platform

HAVING SUM(spend) > 0

ORDER BY roi DESC;



SELECT
    platform,
    COUNT(DISTINCT campaign_id) AS campaigns
FROM marketing_campaigns
GROUP BY platform
ORDER BY campaigns DESC;



SELECT
    platform,

    COUNT(DISTINCT campaign_id) AS campaigns,

    ROUND(
        SUM(revenue)/COUNT(DISTINCT campaign_id),
        2
    ) AS avg_revenue_per_campaign

FROM marketing_campaigns

GROUP BY platform

ORDER BY avg_revenue_per_campaign DESC;



SELECT
    platform,

    COUNT(DISTINCT campaign_id) AS campaigns,

    ROUND(
        SUM(spend)/COUNT(DISTINCT campaign_id),
        2
    ) AS avg_spend_per_campaign

FROM marketing_campaigns

GROUP BY platform

ORDER BY avg_spend_per_campaign DESC;



SELECT
    platform,

    ROUND(
        SUM(conversions)*100.0/SUM(clicks),
        2
    ) AS conversion_rate

FROM marketing_campaigns

GROUP BY platform

HAVING SUM(clicks) > 0

ORDER BY conversion_rate DESC;



-- ==========================================================
-- 10. Platform-wise Profit
-- ==========================================================

SELECT
    platform,
    ROUND(SUM(revenue) - SUM(spend), 2) AS profit
FROM marketing_campaigns
GROUP BY platform
ORDER BY profit DESC;



-- ==========================================================
-- 11. Platform Performance Category
-- ==========================================================

SELECT
    platform,

    ROUND(
        SUM(revenue) / SUM(spend),
        2
    ) AS roas,

    CASE
        WHEN SUM(revenue) / SUM(spend) >= 5 THEN 'Excellent'
        WHEN SUM(revenue) / SUM(spend) >= 3 THEN 'Good'
        WHEN SUM(revenue) / SUM(spend) >= 2 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance

FROM marketing_campaigns

GROUP BY platform

HAVING SUM(spend) > 0

ORDER BY roas DESC;



-- =====================================================
-- 12. Best Performing Platform for Each Marketing Objective
-- =====================================================

SELECT
    objective,
    platform,
    revenue
FROM (
    SELECT
        objective,
        platform,
        ROUND(SUM(revenue), 2) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY objective
            ORDER BY SUM(revenue) DESC
        ) AS rn
    FROM marketing_campaigns
    GROUP BY objective, platform
) AS ranked_platforms
WHERE rn = 1
ORDER BY objective;



-- =====================================================
-- Business Insights
-- =====================================================

-- 1. Google Search generated the highest revenue,
--    conversions, and clicks despite not having the
--    highest number of impressions.

-- 2. Google Search achieved the strongest CTR,
--    Conversion Rate, ROAS, and overall marketing efficiency
--    among all advertising platforms.

-- 3. Approximately 72.6% of total campaign revenue
--    originated from Google Search, making it the
--    primary revenue-driving platform.

-- 4. Advertising spend was distributed relatively evenly
--    across platforms; however, revenue generation varied
--    significantly.

-- 5. Google Search was the only platform generating
--    positive ROI, while all remaining platforms
--    produced negative returns.

-- 6. Meta hosted the highest number of campaigns,
--    but campaign volume did not translate into
--    superior financial performance.

-- 7. Meta recorded the highest average revenue per campaign,
--    whereas Google Search generated the highest overall revenue.

-- 8. Google Search and LinkedIn had the highest average
--    campaign spend, indicating larger investment per campaign.

-- 9. Google Search achieved the highest conversion rate,
--    demonstrating superior ability to convert users
--    into customers.

-- 10. Google Search generated more than 7.6 million
--     in overall profit, while other platforms
--     operated at a net loss.

-- 11. Platform performance classification identified
--     Google Search as the strongest revenue-generating
--     platform, while other platforms require optimization.

-- 12. Google Search emerged as the best-performing platform
--     for Sales and Lead Generation objectives,
--     confirming its effectiveness for conversion-focused
--     marketing strategies.