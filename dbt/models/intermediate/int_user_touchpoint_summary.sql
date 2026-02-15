-- User journey touchpoint aggregations
-- This intermediate model is used by user_journey

with touchpoints as (
    select * from {{ ref('stg_attribution_touchpoints') }}
)

select
    user_id,
    count(distinct touchpoint_id) as total_touchpoints,
    count(distinct session_id) as total_sessions,
    count(distinct campaign_id) as campaigns_touched,
    count(distinct channel) as channels_used,
    min(timestamp) as first_touch_date,
    max(timestamp) as last_touch_date,
    EXTRACT(DAY FROM max(timestamp) - min(timestamp))::int as journey_length_days
from touchpoints
group by user_id
