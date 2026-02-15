-- Get touchpoints for users who converted
-- This intermediate model is used by channel_attribution

with touchpoints as (
    select * from {{ ref('stg_attribution_touchpoints') }}
),

conversions as (
    select * from {{ ref('stg_conversions') }}
)

select
    t.user_id,
    t.channel,
    t.touchpoint_position,
    t.campaign_id,
    t.timestamp as touchpoint_timestamp,
    c.conversion_id,
    c.conversion_value,
    c.timestamp as conversion_timestamp,

    -- Identify first and last touchpoints per conversion
    min(t.touchpoint_position) over (partition by c.conversion_id) as first_position,
    max(t.touchpoint_position) over (partition by c.conversion_id) as last_position
from touchpoints t
inner join conversions c
    on t.user_id = c.user_id
    and t.timestamp <= c.timestamp
