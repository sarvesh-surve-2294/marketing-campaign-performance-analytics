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
