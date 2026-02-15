-- Calculate attribution credit by different models
-- This intermediate model is used by channel_attribution

with converting_touchpoints as (
    select * from {{ ref('int_converting_user_touchpoints') }}
)

select
    channel,
    conversion_id,
    conversion_value,

    -- First-touch attribution (100% credit to first touchpoint)
    case
        when touchpoint_position = first_position then conversion_value
        else 0
    end as first_touch_value,

    -- Last-touch attribution (100% credit to last touchpoint)
    case
        when touchpoint_position = last_position then conversion_value
        else 0
    end as last_touch_value,

    -- Linear attribution (equal credit to all touchpoints)
    conversion_value / count(*) over (partition by conversion_id) as linear_value

from converting_touchpoints
