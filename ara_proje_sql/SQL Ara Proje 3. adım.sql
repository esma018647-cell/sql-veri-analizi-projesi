

select* from facebook_ads_basic_daily;

select* from google_ads_basic_daily;
 
select* from facebook_adset;
 
select* from facebook_campaign;	    




---sql ara proje--- 
 

----- 1. görev 3. adım----
 

WITH fb AS (
    SELECT
        DATE_TRUNC('week', f.ad_date)::date AS week_start,
        COALESCE(fc.campaign_name, 'Unknown Facebook Campaign') AS campaign_name,
        SUM(COALESCE(f.value, 0)) AS total_value
    FROM facebook_ads_basic_daily f
    LEFT JOIN facebook_campaign fc
        ON f.campaign_id = fc.campaign_id
    GROUP BY DATE_TRUNC('week', f.ad_date), COALESCE(fc.campaign_name, 'Unknown Facebook Campaign')
),

ga AS (
    SELECT
        DATE_TRUNC('week', g.ad_date)::date AS week_start,
        COALESCE(g.campaign_name, 'Unknown Google Campaign') AS campaign_name,
        SUM(COALESCE(g.value, 0)) AS total_value
    FROM google_ads_basic_daily g
    GROUP BY DATE_TRUNC('week', g.ad_date)::date, COALESCE(g.campaign_name, 'Unknown Google Campaign')
),

combined AS (
    SELECT * FROM fb
    UNION ALL
    SELECT * FROM ga
),

weekly_totals AS (
    SELECT
        week_start,
        campaign_name,
        SUM(total_value) AS total_value
    FROM combined
    GROUP BY week_start, campaign_name
),

ranked AS (
    SELECT
        week_start,
        campaign_name,
        total_value,
        RANK() OVER (ORDER BY total_value DESC) AS rnk
    FROM weekly_totals
)

SELECT
    week_start AS record_week,
    campaign_name,
    total_value AS record_value
FROM ranked
WHERE rnk = 1;


 
 
 
