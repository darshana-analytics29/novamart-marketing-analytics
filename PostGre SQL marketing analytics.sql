
--create table marketing raw
CREATE TABLE marketing_raw (
    campaign_record_id TEXT,
    campaign_date TEXT,
    campaign_name TEXT,
    channel TEXT,
    campaign_type TEXT,
    target_audience TEXT,
    region TEXT,
    device_type TEXT,
    spend TEXT,
    impressions TEXT,
    clicks TEXT,
    conversions TEXT,
    revenue TEXT,
    new_customers TEXT,
    campaign_status TEXT
);

select count(*) from marketing_raw;

--check for missing values
SELECT
    COUNT(*) FILTER (WHERE campaign_record_id IS NULL OR TRIM(campaign_record_id) = '') AS missing_id,
    COUNT(*) FILTER (WHERE campaign_date IS NULL OR TRIM(campaign_date) = '') AS missing_date,
    COUNT(*) FILTER (WHERE campaign_name IS NULL OR TRIM(campaign_name) = '') AS missing_campaign,
    COUNT(*) FILTER (WHERE channel IS NULL OR TRIM(channel) = '') AS missing_channel,
    COUNT(*) FILTER (WHERE campaign_type IS NULL OR TRIM(campaign_type) = '') AS missing_type,
    COUNT(*) FILTER (WHERE target_audience IS NULL OR TRIM(target_audience) = '') AS missing_audience,
    COUNT(*) FILTER (WHERE region IS NULL OR TRIM(region) = '') AS missing_region,
    COUNT(*) FILTER (WHERE device_type IS NULL OR TRIM(device_type) = '') AS missing_device,
    COUNT(*) FILTER (WHERE spend IS NULL OR TRIM(spend) = '') AS missing_spend,
    COUNT(*) FILTER (WHERE impressions IS NULL OR TRIM(impressions) = '') AS missing_impressions,
    COUNT(*) FILTER (WHERE clicks IS NULL OR TRIM(clicks) = '') AS missing_clicks,
    COUNT(*) FILTER (WHERE conversions IS NULL OR TRIM(conversions) = '') AS missing_conversions,
    COUNT(*) FILTER (WHERE revenue IS NULL OR TRIM(revenue) = '') AS missing_revenue,
    COUNT(*) FILTER (WHERE new_customers IS NULL OR TRIM(new_customers) = '') AS missing_new_customers,
    COUNT(*) FILTER (WHERE campaign_status IS NULL OR TRIM(campaign_status) = '') AS missing_status
FROM marketing_raw;

--check for duplicate records
SELECT
    campaign_record_id,
    COUNT(*) AS record_count
FROM marketing_raw
GROUP BY campaign_record_id
HAVING COUNT(*) > 1;

--check numerical data
SELECT
    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(spend), '') IS NOT NULL
        AND TRIM(spend) !~ '^-?[0-9]+([.][0-9]+)?$'
    ) AS invalid_spend,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(impressions), '') IS NOT NULL
        AND TRIM(impressions) !~ '^-?[0-9]+([.][0-9]+)?$'
    ) AS invalid_impressions,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(clicks), '') IS NOT NULL
        AND TRIM(clicks) !~ '^-?[0-9]+([.][0-9]+)?$'
    ) AS invalid_clicks,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(conversions), '') IS NOT NULL
        AND TRIM(conversions) !~ '^-?[0-9]+([.][0-9]+)?$'
    ) AS invalid_conversions,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(revenue), '') IS NOT NULL
        AND TRIM(revenue) !~ '^-?[0-9]+([.][0-9]+)?$'
    ) AS invalid_revenue,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(new_customers), '') IS NOT NULL
        AND TRIM(new_customers) !~ '^-?[0-9]+([.][0-9]+)?$'
    ) AS invalid_new_customers
FROM marketing_raw;

--check for negative values
SELECT
    COUNT(*) FILTER (WHERE NULLIF(TRIM(spend), '')::NUMERIC < 0) AS negative_spend,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(impressions), '')::NUMERIC < 0) AS negative_impressions,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(clicks), '')::NUMERIC < 0) AS negative_clicks,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(conversions), '')::NUMERIC < 0) AS negative_conversions,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(revenue), '')::NUMERIC < 0) AS negative_revenue,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(new_customers), '')::NUMERIC < 0) AS negative_new_customers
FROM marketing_raw;

--Check Marketing Funnel Consistency
SELECT
    COUNT(*) FILTER (
        WHERE clicks::NUMERIC > impressions::NUMERIC
    ) AS clicks_exceed_impressions,

    COUNT(*) FILTER (
        WHERE conversions::NUMERIC > clicks::NUMERIC
    ) AS conversions_exceed_clicks
FROM marketing_raw;

--check category values
SELECT
    'Channel' AS column_name,
    channel AS category_value,
    COUNT(*) AS records
FROM marketing_raw
GROUP BY channel

UNION ALL

SELECT
    'Campaign Type',
    campaign_type,
    COUNT(*)
FROM marketing_raw
GROUP BY campaign_type

UNION ALL

SELECT
    'Device Type',
    device_type,
    COUNT(*)
FROM marketing_raw
GROUP BY device_type

UNION ALL

SELECT
    'Campaign Status',
    campaign_status,
    COUNT(*)
FROM marketing_raw
GROUP BY campaign_status

ORDER BY column_name, category_value;

--Check Target Audience and Region
SELECT
    'Target Audience' AS column_name,
    target_audience AS category_value,
    COUNT(*) AS records
FROM marketing_raw
GROUP BY target_audience

UNION ALL

SELECT
    'Region',
    region,
    COUNT(*)
FROM marketing_raw
GROUP BY region

ORDER BY column_name, category_value;

--date check
SELECT
    COUNT(*) FILTER (
        WHERE campaign_date IS NULL
           OR TRIM(campaign_date) = ''
    ) AS missing_dates,

    COUNT(*) FILTER (
        WHERE TRIM(campaign_date) !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
    ) AS invalid_date_format,

    MIN(campaign_date) AS earliest_date,
    MAX(campaign_date) AS latest_date
FROM marketing_raw;

--create the cleaned table
CREATE TABLE marketing_cleaned AS
SELECT
    TRIM(campaign_record_id) AS campaign_record_id,
    TRIM(campaign_date)::DATE AS campaign_date,
    TRIM(campaign_name) AS campaign_name,
    TRIM(channel) AS channel,
    TRIM(campaign_type) AS campaign_type,
    TRIM(target_audience) AS target_audience,
    TRIM(region) AS region,
    TRIM(device_type) AS device_type,
    TRIM(spend)::NUMERIC(14,2) AS spend,
    TRIM(impressions)::BIGINT AS impressions,
    TRIM(clicks)::BIGINT AS clicks,
    TRIM(conversions)::BIGINT AS conversions,
    TRIM(revenue)::NUMERIC(14,2) AS revenue,
    TRIM(new_customers)::BIGINT AS new_customers,
    TRIM(campaign_status) AS campaign_status
FROM marketing_raw;

select * from marketing_cleaned

--Calculate Overall Marketing KPIs
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT campaign_name) AS unique_campaigns,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,  
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100                  
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(clicks), 0), 2
    ) AS cpc,

    ROUND(
        SUM(spend) / NULLIF(SUM(conversions), 0), 2
    ) AS cpa,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned;

--Analyse performance by marketing channel
SELECT
    channel,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
	ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(clicks), 0), 2
    ) AS cpc,

    ROUND(
        SUM(spend) / NULLIF(SUM(conversions), 0), 2
    ) AS cpa,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY channel
ORDER BY total_revenue DESC;

--Campaign Type Analysis
SELECT
    campaign_type,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY campaign_type
ORDER BY total_revenue DESC;

--Regional Performance Analysis
SELECT
    region,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY region
ORDER BY total_revenue DESC;

--Device Performance Analysis
SELECT
    device_type,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY device_type
ORDER BY total_revenue DESC;

--Target Audience Analysis
SELECT
    target_audience,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY target_audience
ORDER BY total_revenue DESC;

--Campaign Status Analysis
SELECT
    campaign_status,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY campaign_status
ORDER BY total_revenue DESC;

--Monthly Marketing Performance
SELECT
    DATE_TRUNC('month', campaign_date)::DATE AS campaign_month,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY DATE_TRUNC('month', campaign_date)
ORDER BY campaign_month;

--Quarterly Marketing Performance
SELECT
    DATE_TRUNC('quarter', campaign_date)::DATE AS campaign_quarter,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY DATE_TRUNC('quarter', campaign_date)
ORDER BY campaign_quarter;

--Performance by Campaign Name
SELECT
    campaign_name,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(clicks)::NUMERIC * 100
        / NULLIF(SUM(impressions), 0), 2
    ) AS ctr_percent,

    ROUND(
        SUM(conversions)::NUMERIC * 100
        / NULLIF(SUM(clicks), 0), 2
    ) AS conversion_rate_percent,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY campaign_name
ORDER BY total_revenue DESC;

--Performance by Campaign Type and Channel
SELECT
    campaign_type,
    channel,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas

FROM marketing_cleaned
GROUP BY campaign_type, channel
ORDER BY roas DESC;

--Top 10 Campaigns by ROAS
SELECT
    campaign_name,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,
    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas
FROM marketing_cleaned
GROUP BY campaign_name
ORDER BY roas DESC
LIMIT 10;

--Lowest 10 Campaigns by ROAS
SELECT
    campaign_name,
    COUNT(*) AS total_records,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac,
    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas
FROM marketing_cleaned
GROUP BY campaign_name
ORDER BY roas ASC
LIMIT 10;

--Monthly Performance by Channel
SELECT
    DATE_TRUNC('month', campaign_date)::DATE AS campaign_month,
    channel,
    ROUND(SUM(spend), 2) AS total_spend,
    SUM(conversions) AS total_conversions,
    SUM(new_customers) AS total_new_customers,
    ROUND(SUM(revenue), 2) AS total_revenue,

    ROUND(
        SUM(revenue) / NULLIF(SUM(spend), 0), 2
    ) AS roas,

    ROUND(
        SUM(spend) / NULLIF(SUM(new_customers), 0), 2
    ) AS cac

FROM marketing_cleaned
GROUP BY
    DATE_TRUNC('month', campaign_date),
    channel
ORDER BY
    campaign_month,
    channel;




 
