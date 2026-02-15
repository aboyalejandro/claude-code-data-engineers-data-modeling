-- User conversion aggregations
-- This intermediate model is used by user_journey

with conversions as (
    select * from {{ ref('stg_conversions') }}
)

select
    user_id,
    count(distinct conversion_id) as total_conversions,
    sum(conversion_value) as total_conversion_value,
    min(timestamp) as first_conversion_date,
    max(timestamp) as last_conversion_date
from conversions
group by user_id
