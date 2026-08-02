-- =====================================================
-- 1. Total Number of Campaigns
-- =====================================================

SELECT
    COUNT(DISTINCT campaign_id) AS total_campaigns
FROM marketing_campaigns;


-- =====================================================
-- 2. Overall Marketing Performance
-- =====================================================

SELECT
    ROUND(SUM(spend),2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    ROUND(SUM(revenue),2) AS total_revenue
FROM marketing_campaigns;


-- =====================================================
-- 3. Average Marketing KPIs
-- =====================================================

SELECT
    ROUND(AVG(ctr),2) AS avg_ctr,
    ROUND(AVG(cpc),2) AS avg_cpc,
    ROUND(AVG(cpm),2) AS avg_cpm,
    ROUND(AVG(cpa),2) AS avg_cpa,
    ROUND(AVG(conversion_rate),2) AS avg_conversion_rate,
    ROUND(AVG(roas),2) AS avg_roas,
    ROUND(AVG(roi),2) AS avg_roi
FROM marketing_campaigns;


-- =========================================================
-- 4. Top 10 Revenue Generating Campaigns
-- =========================================================

SELECT
    campaign_name,
    platform,
    objective,
    ROUND(SUM(spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM marketing_campaigns
GROUP BY campaign_name, platform, objective
ORDER BY total_revenue DESC
LIMIT 10;


-- =========================================================
-- 5. Top 10 Highest ROAS Campaigns
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND(SUM(spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / SUM(spend), 2) AS roas
FROM marketing_campaigns
GROUP BY campaign_name, platform
HAVING SUM(spend) > 0
ORDER BY roas DESC
LIMIT 10;


-- =========================================================
-- 6. Top 10 Highest ROI Campaigns
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND(SUM(spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        ((SUM(revenue) - SUM(spend)) / SUM(spend)) * 100,
        2
    ) AS roi
FROM marketing_campaigns
GROUP BY campaign_name, platform
HAVING SUM(spend) > 0
ORDER BY roi DESC
LIMIT 10;


-- =========================================================
-- 7. Lowest Revenue Campaigns
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND(SUM(spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM marketing_campaigns
GROUP BY campaign_name, platform
ORDER BY total_revenue ASC
LIMIT 10;


-- =========================================================
-- 8. Highest Spend Campaigns
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND(SUM(spend), 2) AS total_spend,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM marketing_campaigns
GROUP BY campaign_name, platform
ORDER BY total_spend DESC
LIMIT 10;


-- =========================================================
-- 9. Most Efficient Campaigns
-- =========================================================

SELECT
    campaign_name,
    platform,
    ROUND((SUM(clicks) / SUM(impressions)) * 100, 2) AS ctr,
    ROUND((SUM(conversions) / SUM(clicks)) * 100, 2) AS conversion_rate,
    ROUND(SUM(revenue) / SUM(spend), 2) AS roas
FROM marketing_campaigns
GROUP BY campaign_name, platform
HAVING SUM(clicks) > 0
   AND SUM(impressions) > 0
   AND SUM(spend) > 0
ORDER BY conversion_rate DESC, roas DESC
LIMIT 10;


-- =====================================================
-- 10. Campaign Performance Summary
-- =====================================================

SELECT
    campaign_name,
    COUNT(*) AS ads,
    ROUND(SUM(spend),2) AS total_spend,
    ROUND(SUM(revenue),2) AS total_revenue,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions
FROM marketing_campaigns
GROUP BY campaign_name
ORDER BY total_revenue DESC;


-- =====================================================
-- 11. Campaign Profit
-- =====================================================

SELECT
    campaign_name,
    ROUND(SUM(revenue-spend),2) AS profit
FROM marketing_campaigns
GROUP BY campaign_name
ORDER BY profit DESC;


-- =====================================================
-- 12. Loss Making Campaigns
-- =====================================================

SELECT
    campaign_name,
    ROUND(SUM(revenue-spend),2) AS profit
FROM marketing_campaigns
GROUP BY campaign_name
HAVING profit < 0
ORDER BY profit;


-- =====================================================
-- 13. Campaigns Above Average Revenue
-- =====================================================

SELECT
    campaign_name,
    ROUND(revenue,2) AS revenue
FROM marketing_campaigns
WHERE revenue >
(
    SELECT AVG(revenue)
    FROM marketing_campaigns
)
ORDER BY revenue DESC;


-- =====================================================
-- 14. Campaign Performance Category
-- =====================================================

SELECT
    campaign_name,
    ROUND(roas,2) AS roas,
    CASE
        WHEN roas >= 5 THEN 'Excellent'
        WHEN roas >= 3 THEN 'Good'
        WHEN roas >= 1 THEN 'Average'
        ELSE 'Poor'
    END AS performance
FROM marketing_campaigns
ORDER BY roas DESC;


-- =====================================================
-- 15. ROI Performance Category
-- =====================================================

SELECT
    campaign_name,
    ROUND(roi,2) AS roi,
    CASE
        WHEN roi >= 100 THEN 'High ROI'
        WHEN roi >= 50 THEN 'Moderate ROI'
        WHEN roi >= 0 THEN 'Low ROI'
        ELSE 'Negative ROI'
    END AS roi_category
FROM marketing_campaigns
ORDER BY roi DESC;


-- =====================================================
-- Business Insights
-- =====================================================

-- 1. The dataset contains 25,548 unique marketing campaigns,
--    providing sufficient data for campaign performance analysis.

-- 2. Marketing campaigns generated over 1.70 billion impressions,
--    25.6 million clicks, and 322K+ conversions with overall
--    revenue exceeding advertising spend.

-- 3. Average campaign performance shows a CTR of 1.82%,
--    ROAS of 1.08, and ROI of 7.62%, indicating an overall
--    positive return from marketing investments.

-- 4. Google Search Sales campaigns consistently generated the
--    highest revenue, demonstrating the effectiveness of
--    search-based conversion campaigns.

-- 5. Top ROAS campaigns achieved exceptional returns with
--    relatively low advertising spend, highlighting highly
--    efficient budget utilization.

-- 6. Highest ROI campaigns were primarily conversion-focused,
--    indicating strong profitability relative to investment.

-- 7. Awareness campaigns generated little or no direct revenue,
--    which is expected as their primary objective is brand
--    visibility rather than immediate conversions.

-- 8. Several high-budget campaigns produced low or zero revenue,
--    suggesting that increased spending alone does not guarantee
--    better business outcomes.

-- 9. The most efficient campaigns combined high CTR,
--    strong conversion rates, and excellent ROAS,
--    making them suitable candidates for scaling.

-- 10. Google Search conversion campaigns consistently outperformed
--     other campaign types across revenue, profitability,
--     and efficiency metrics.

-- 11. Profit analysis revealed that only a small group of campaigns
--     contributed the majority of overall profit.

-- 12. Revenue distribution indicates that a limited number of
--     campaigns generated a significant share of total revenue,
--     following the Pareto principle.

-- 13. Campaign classification using ROAS helps identify campaigns
--     suitable for scaling versus those requiring optimization.

-- 14. ROI categorization further supports budget allocation by
--     distinguishing highly profitable campaigns from
--     underperforming ones.