-- ============================================================
-- 04. Time Performance Analysis
-- ============================================================

USE marketing_campaign_analysis;

-- ============================================================
-- 1. Revenue by Year
-- ============================================================

SELECT
    YEAR(date) AS year,
    ROUND(SUM(revenue),2) AS total_revenue,
    ROUND(SUM(spend),2) AS total_spend,
    SUM(conversions) AS total_conversions
FROM marketing_campaigns
GROUP BY YEAR(date)
ORDER BY year;


-- ============================================================
-- 2. Spend by Year
-- ============================================================

SELECT
    YEAR(date) AS year,
    ROUND(SUM(spend),2) AS total_spend
FROM marketing_campaigns
GROUP BY YEAR(date)
ORDER BY year;


-- ============================================================
-- 3. Monthly Revenue Trend
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTH(date) AS month_no,
    MONTHNAME(date) AS month,
    ROUND(SUM(revenue),2) AS total_revenue
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY year, month_no;


-- ============================================================
-- 4. Monthly Spend Trend
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTH(date) AS month_no,
    MONTHNAME(date) AS month,
    ROUND(SUM(spend),2) AS total_spend
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY year, month_no;


-- ============================================================
-- 5. Monthly ROAS
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTHNAME(date) AS month,
    ROUND(SUM(spend),2) AS spend,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
HAVING SUM(spend) > 0
ORDER BY year, MONTH(date);


-- ============================================================
-- 6. Monthly ROI
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTHNAME(date) AS month,
    ROUND(SUM(spend),2) AS spend,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(((SUM(revenue)-SUM(spend))/SUM(spend))*100,2) AS roi
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
HAVING SUM(spend) > 0
ORDER BY year, MONTH(date);


-- ============================================================
-- 7. Quarterly Performance
-- ============================================================

SELECT
    YEAR(date) AS year,
    QUARTER(date) AS quarter,
    ROUND(SUM(spend),2) AS spend,
    ROUND(SUM(revenue),2) AS revenue,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas
FROM marketing_campaigns
GROUP BY YEAR(date), QUARTER(date)
HAVING SUM(spend) > 0
ORDER BY YEAR(date), QUARTER(date);


-- ============================================================
-- 8. Campaigns Started per Month
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTHNAME(date) AS month,
    COUNT(DISTINCT campaign_id) AS campaigns
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY year, MONTH(date);


-- ============================================================
-- 9. Best Revenue Months
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTHNAME(date) AS month,
    ROUND(SUM(revenue),2) AS revenue
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- 10. Lowest Revenue Months
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTHNAME(date) AS month,
    ROUND(SUM(revenue),2) AS revenue
FROM marketing_campaigns
GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)
ORDER BY revenue ASC
LIMIT 10;


-- ============================================================
-- 11. Monthly Performance Category
-- ============================================================

SELECT
    YEAR(date) AS year,
    MONTHNAME(date) AS month,
    ROUND(SUM(revenue)/SUM(spend),2) AS roas,

    CASE
        WHEN SUM(revenue)/SUM(spend) >= 5 THEN 'Excellent'
        WHEN SUM(revenue)/SUM(spend) >= 3 THEN 'Good'
        WHEN SUM(revenue)/SUM(spend) >= 2 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance

FROM marketing_campaigns

GROUP BY
    YEAR(date),
    MONTH(date),
    MONTHNAME(date)

HAVING SUM(spend) > 0

ORDER BY year, MONTH(date);


-- ============================================================
-- 12. Year-over-Year Revenue Growth
-- ============================================================

WITH yearly_revenue AS
(
    SELECT
        YEAR(date) AS year,
        ROUND(SUM(revenue),2) AS revenue
    FROM marketing_campaigns
    GROUP BY YEAR(date)
)

SELECT
    year,
    revenue,
    LAG(revenue) OVER(ORDER BY year) AS previous_year,
    ROUND(
        ((revenue-LAG(revenue) OVER(ORDER BY year))
        /
        LAG(revenue) OVER(ORDER BY year))*100,
    2) AS growth_percentage
FROM yearly_revenue;


-- ============================================================
-- 13. Running Revenue by Month
-- ============================================================

WITH monthly_revenue AS
(
    SELECT
        YEAR(date) AS year,
        MONTH(date) AS month_no,
        MONTHNAME(date) AS month,
        ROUND(SUM(revenue),2) AS revenue
    FROM marketing_campaigns
    GROUP BY
        YEAR(date),
        MONTH(date),
        MONTHNAME(date)
)

SELECT
    year,
    month,
    revenue,

    SUM(revenue) OVER(
        PARTITION BY year
        ORDER BY month_no
    ) AS cumulative_revenue

FROM monthly_revenue;


-- ============================================================
-- 14. Highest Revenue Quarter
-- ============================================================

SELECT
    year,
    CONCAT('Q', quarter) AS quarter,
    revenue
FROM (
    SELECT
        YEAR(date) AS year,
        QUARTER(date) AS quarter,
        ROUND(SUM(revenue), 2) AS revenue
    FROM marketing_campaigns
    GROUP BY
        YEAR(date),
        QUARTER(date)
) AS quarterly_revenue
ORDER BY revenue DESC
LIMIT 10;


-- ============================================================
-- 15. Highest Spend Quarter
-- ============================================================

SELECT
    year,
    CONCAT('Q', quarter) AS quarter,
    spend
FROM
(
    SELECT
        YEAR(date) AS year,
        QUARTER(date) AS quarter,
        ROUND(SUM(spend),2) AS spend
    FROM marketing_campaigns
    GROUP BY
        YEAR(date),
        QUARTER(date)
) AS quarterly_spend
ORDER BY spend DESC
LIMIT 10;

-- ============================================================
-- Business Insights
-- ============================================================

-- Query 1:
-- Annual revenue peaked in 2024 with over $5.0M generated,
-- representing a 5.9% increase over 2023. Revenue declined
-- slightly in 2025 despite similar marketing spend.

-- Query 2:
-- Marketing spend remained relatively consistent across all
-- three years, indicating stable budgeting and investment
-- strategies.

-- Query 3:
-- Revenue consistently peaked during October, November, and
-- December across multiple years, highlighting Q4 as the
-- strongest sales season.

-- Query 4:
-- Marketing expenditure was highest during October-November,
-- suggesting increased advertising investment ahead of major
-- shopping and holiday seasons.

-- Query 5:
-- ROAS reached its highest values during Q4 months,
-- demonstrating that marketing campaigns generated the
-- greatest return on investment during the final quarter.

-- Query 6:
-- Monthly ROI fluctuated throughout the year, with several
-- months producing negative ROI. However, Q4 consistently
-- delivered the strongest profitability.

-- Query 7:
-- Q4 generated the highest quarterly revenue every year,
-- confirming strong seasonal demand and effective campaign
-- execution during the final quarter.

-- Query 8:
-- Campaign launches remained evenly distributed throughout
-- the year, indicating continuous marketing activity rather
-- than relying on a single seasonal campaign period.

-- Query 9:
-- November and October repeatedly ranked among the highest
-- revenue-generating months, making them the most valuable
-- periods for marketing investments.

-- Query 10:
-- June through August consistently produced the lowest
-- revenues, indicating seasonal slowdowns and opportunities
-- for promotional campaigns to improve performance.

-- Query 11:
-- Most months recorded ROAS below 2, suggesting that campaign
-- efficiency can be further optimized. November 2024 was the
-- only month achieving the 'Average' performance category.

-- Query 12:
-- Revenue increased by 5.9% in 2024 compared to 2023 but
-- declined by 9.26% in 2025, indicating changing market
-- conditions or reduced campaign effectiveness.

-- Query 13:
-- Cumulative revenue increased steadily throughout each year,
-- with the sharpest growth occurring during Q4, reflecting
-- stronger year-end campaign performance.

-- Query 14:
-- Q4 consistently generated the highest quarterly revenue,
-- with Q4 2024 delivering the strongest quarterly performance
-- across the entire dataset.

-- Query 15:
-- Marketing spend was highest during Q4 every year, aligning
-- closely with the highest quarterly revenues and validating
-- increased investment during peak demand periods.