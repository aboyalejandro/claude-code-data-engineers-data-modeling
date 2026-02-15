-- Simplified mart model using intermediate models for session and conversion metrics

with campaigns as (
    select * from {{ ref('stg_campaigns_daily') }}
),

session_metrics as (
    select * from {{ ref('int_session_metrics_by_campaign') }}
),

conversion_metrics as (
    select * from {{ ref('int_conversion_metrics_by_campaign') }}
),

final as (
    select
        c.campaign_id,
        c.date,
        c.campaign_name,
        c.channel,
        c.status,

        -- Spend metrics
        c.daily_budget,
        c.spend,

        -- Impression & Click metrics
        c.impressions,
        c.clicks,
        c.ctr,
        c.cpc,

        -- Session metrics
        coalesce(s.total_sessions, 0) as total_sessions,
        coalesce(s.unique_users, 0) as unique_users,
        coalesce(s.avg_session_duration, 0) as avg_session_duration,
        coalesce(s.avg_pages_per_session, 0) as avg_pages_per_session,
        coalesce(s.engaged_sessions, 0) as engaged_sessions,
        coalesce(s.mobile_sessions, 0) as mobile_sessions,
        coalesce(s.desktop_sessions, 0) as desktop_sessions,

        -- Conversion metrics
        coalesce(cv.total_conversions, 0) as total_conversions,
        coalesce(cv.converting_users, 0) as converting_users,
        coalesce(cv.total_revenue, 0) as total_revenue,
        coalesce(cv.avg_order_value, 0) as avg_order_value,

        -- Calculated metrics
        case
            when s.total_sessions > 0 then (cv.total_conversions::float / s.total_sessions::float)
            else 0
        end as conversion_rate,

        case
            when c.spend > 0 then (cv.total_revenue / c.spend)
            else 0
        end as roas,

        case
            when cv.total_conversions > 0 then (c.spend / cv.total_conversions)
            else 0
        end as cost_per_conversion,

        case
            when c.clicks > 0 then (s.total_sessions::float / c.clicks::float)
            else 0
        end as click_to_session_rate

    from campaigns c
    left join session_metrics s
        on c.campaign_id = s.campaign_id
        and c.date = s.date
    left join conversion_metrics cv
        on c.campaign_id = cv.campaign_id
        and c.date = cv.date
)

select * from final
