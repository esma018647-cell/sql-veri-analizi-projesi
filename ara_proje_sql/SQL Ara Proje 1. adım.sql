
select* from facebook_ads_basic_daily;

select* from google_ads_basic_daily;
 
select* from facebook_adset;
 
select* from facebook_campaign;	    




---sql ara proje--- 
 




1. görev---1. adım---




WITH unified AS (

    SELECT
        fbd.ad_date,
        'facebook' AS media_source,
        fbd.spend
    FROM facebook_ads_basic_daily fbd
    LEFT JOIN facebook_adset fa ON fbd.adset_id = fa.adset_id
    LEFT JOIN facebook_campaign fc ON fbd.campaign_id = fc.campaign_id

    UNION ALL

    SELECT
        gad.ad_date,
        'google' AS media_source,
        gad.spend
    FROM google_ads_basic_daily gad
)

SELECT
    ad_date,
    media_source,
    AVG(spend) AS avg_spend,
    MAX(spend) AS max_spend,
    MIN(spend) AS min_spend
FROM unified
GROUP BY ad_date, media_source
ORDER BY ad_date, media_source;
 
 
