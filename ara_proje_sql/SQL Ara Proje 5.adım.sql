

select* from facebook_ads_basic_daily;

select* from google_ads_basic_daily;
 
select* from facebook_adset;
 
select* from facebook_campaign;	    




---sql ara proje--- 
 
------1. görev 5. adım-----


WITH unified AS (
  SELECT
    fa.adset_name,
    fbd.ad_date::date AS ad_date
  FROM facebook_ads_basic_daily fbd
  LEFT JOIN facebook_adset fa ON fbd.adset_id = fa.adset_id
  WHERE fbd.impressions > 0 AND fa.adset_name IS NOT NULL
  UNION ALL
  SELECT
    gad.adset_name,
    gad.ad_date::date
  FROM google_ads_basic_daily gad
  WHERE gad.impressions > 0 AND gad.adset_name IS NOT NULL
),
days AS (
  SELECT DISTINCT adset_name, ad_date
  FROM unified
),
ordered AS (
  SELECT
    adset_name,
    ad_date,
    ad_date
      - ROW_NUMBER() OVER (PARTITION BY adset_name ORDER BY ad_date) * INTERVAL '1 day' AS grp
  FROM days
),
grouped AS (
  SELECT
    adset_name,
    MIN(ad_date) AS streak_start,
    MAX(ad_date) AS streak_end,
    COUNT(*)     AS streak_length
  FROM ordered
  GROUP BY adset_name, grp
)
SELECT
  adset_name,
  streak_start,
  streak_end,
  streak_length
FROM grouped
ORDER BY streak_length DESC, adset_name, streak_start
LIMIT 1;




 
 
 
