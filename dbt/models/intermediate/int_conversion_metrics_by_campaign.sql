-- Aggregate conversion metrics by campaign and date
-- This intermediate model is used by campaign_performance

with conversions as (
    select * from {{ ref('stg_conversions') }}
)

select
    attributed_campaign_id as campaign_id,
    date,
    count(distinct conversion_id) as total_conversions,
    count(distinct user_id) as converting_users,
    sum(conversion_value) as total_revenue,
    avg(conversion_value) as avg_order_value
from conversions
group by attributed_campaign_id, date
