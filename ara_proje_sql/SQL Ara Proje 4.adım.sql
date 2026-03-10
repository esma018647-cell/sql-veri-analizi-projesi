

select* from facebook_ads_basic_daily;

select* from google_ads_basic_daily;
 
select* from facebook_adset;
 
select* from facebook_campaign;	    




---sql ara proje--- 
 
----1.Görev 4. Adım-----


with fb as( 
        select f.ad_date,
               c.campaign_name,
               f.reach 
        from  facebook_ads_basic_daily f
        left join facebook_campaign c
        on f.campaign_id=c.campaign_id
),

google as( 
       select ad_date,
              campaign_name,
              reach
        from google_ads_basic_daily       
),

cte as( 
    select ad_date,
           campaign_name,
           reach
    from  fb
    union all
    select ad_date,
           campaign_name,
           reach
    from google      
),

monthly_reach as(   
              select campaign_name,
              date_trunc('month', ad_date)::date as month,
              sum(reach) as total_monthly_reach 
              from cte 
              group by campaign_name,date_trunc('month', ad_date)

),

reach_growth AS (
    SELECT
        campaign_name,
        month,
        total_monthly_reach,
        total_monthly_reach 
            - LAG(total_monthly_reach) OVER (
                PARTITION BY campaign_name
                ORDER BY month
            ) AS reach_increase
    FROM monthly_reach
    )
    SELECT *
FROM reach_growth
WHERE reach_increase IS NOT NULL
ORDER BY reach_increase DESC
LIMIT 1;


 
 
 
