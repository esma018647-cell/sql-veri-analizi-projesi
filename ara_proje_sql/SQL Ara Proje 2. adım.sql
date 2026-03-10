

select* from facebook_ads_basic_daily;

select* from google_ads_basic_daily;
 
select* from facebook_adset;
 
select* from facebook_campaign;	    




---sql ara proje--- 
 

-----1. Görev 2. adım----
 

 WITH unified AS (
    SELECT
        fbd.ad_date,
        fbd.spend,
        fbd.value
    FROM facebook_ads_basic_daily fbd
   

    UNION ALL

    SELECT
        gad.ad_date,
        gad.spend,
        gad.value
    FROM google_ads_basic_daily gad
),

daily AS (
    SELECT
        ad_date,
        SUM(spend) AS total_spend,
        SUM(value) AS total_value
    FROM unified
    GROUP BY ad_date
),

romi_calc AS (
    SELECT
        ad_date,
        1.00 * COALESCE(total_value, 0) / NULLIF(total_spend, 0) AS romi
    FROM daily
)

SELECT
    ad_date,
    romi
FROM romi_calc
WHERE romi IS NOT NULL
ORDER BY romi DESC
LIMIT 5;
 
 
 
