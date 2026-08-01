-- =====================================================
-- Marketing Campaign Performance Analytics
-- Database Schema
-- =====================================================

-- Create Database

CREATE DATABASE IF NOT EXISTS marketing_campaign_analytics;

-- Use Database

USE marketing_campaign_analytics;

-- =====================================================
-- Create Table
-- =====================================================
SHOW TABLES;

DESCRIBE marketing_campaigns;

SHOW VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'local_infile';

CREATE TABLE marketing_campaigns (

    date DATE,

    year INT,
    month INT,
    month_name VARCHAR(20),
    week INT,
    day_of_week VARCHAR(20),
    post_hour INT,

    season VARCHAR(20),
    is_holiday BOOLEAN,
    is_weekend BOOLEAN,

    country VARCHAR(50),
    market_tier VARCHAR(20),

    account VARCHAR(100),
    account_type VARCHAR(20),

    platform VARCHAR(30),
    placement VARCHAR(30),

    funnel_stage VARCHAR(30),
    objective VARCHAR(30),

    theme VARCHAR(50),

    campaign_id VARCHAR(20),
    campaign_name VARCHAR(100),

    ad_group_id VARCHAR(20),
    ad_group_name VARCHAR(100),

    ad_id VARCHAR(20),
    ad_name VARCHAR(100),

    spend DECIMAL(12,2),
    impressions INT,
    reach INT,
    frequency DECIMAL(8,2),

    clicks INT,
    conversions INT,

    revenue DECIMAL(15,2),
    video_views INT,

    ctr DECIMAL(10,2),
    cpc DECIMAL(10,2),
    cpm DECIMAL(10,2),
    cpa DECIMAL(10,2),

    conversion_rate DECIMAL(10,2),

    roas DECIMAL(10,2),
    roi DECIMAL(12,2),

    revenue_per_click DECIMAL(12,2),
    revenue_per_conversion DECIMAL(12,2)

);



-- =====================================================
-- Verify Imported Data
-- =====================================================

SELECT *
FROM marketing_campaigns
LIMIT 10;

SELECT COUNT(*) AS total_records
FROM marketing_campaigns;

DESCRIBE marketing_campaigns;

SHOW TABLES;

SHOW DATABASES;