-- Simplified mart model using intermediate models for user journey metrics

with user_touchpoint_summary as (
    select * from {{ ref('int_user_touchpoint_summary') }}
),

user_conversions as (
    select * from {{ ref('int_user_conversions') }}
),

final as (
    select
        u.user_id,
        u.total_touchpoints,
        u.total_sessions,
        u.campaigns_touched,
        u.channels_used,
        u.first_touch_date,
        u.last_touch_date,
        u.journey_length_days,

        -- Conversion metrics
        coalesce(c.total_conversions, 0) as total_conversions,
        coalesce(c.total_conversion_value, 0) as total_conversion_value,
        c.first_conversion_date,
        c.last_conversion_date,

        -- User classification
        case
            when c.total_conversions > 0 then 'converted'
            else 'non-converted'
        end as user_type,

        case
            when u.channels_used >= 3 then 'multi-channel'
            when u.channels_used = 2 then 'dual-channel'
            else 'single-channel'
        end as channel_behavior,

        case
            when u.journey_length_days >= 7 then 'long'
            when u.journey_length_days >= 1 then 'medium'
            else 'short'
        end as journey_length_category

    from user_touchpoint_summary u
    left join user_conversions c
        on u.user_id = c.user_id
)

select * from final
