-- Calculate funnel stage counts from staging models
-- Grain: one row per campaign
-- Upstream: stg_campaigns_daily, stg_sessions, stg_conversions

with campaigns as (
    select
        campaign_id,
        max(campaign_name) as campaign_name,
        max(channel) as channel,
        coalesce(sum(impressions), 0) as total_impressions,
        coalesce(sum(clicks), 0) as total_clicks
    from {{ ref('stg_campaigns_daily') }}
    group by campaign_id
),

session_counts as (
    select
        campaign_id,
        count(distinct session_id) as total_sessions
    from {{ ref('stg_sessions') }}
    group by campaign_id
),

conversion_counts as (
    select
        attributed_campaign_id as campaign_id,
        count(distinct conversion_id) as total_conversions
    from {{ ref('stg_conversions') }}
    group by attributed_campaign_id
),

final as (
    select
        c.campaign_id,
        c.campaign_name,
        c.channel,
        c.total_impressions,
        c.total_clicks,
        coalesce(s.total_sessions, 0) as total_sessions,
        coalesce(cv.total_conversions, 0) as total_conversions,

        -- Drop-off rates
        case
            when c.total_impressions > 0 then (c.total_clicks::float / c.total_impressions::float)
            else 0
        end as click_through_rate,

        case
            when c.total_clicks > 0 then (coalesce(s.total_sessions, 0)::float / c.total_clicks::float)
            else 0
        end as click_to_session_rate,

        case
            when coalesce(s.total_sessions, 0) > 0 then (coalesce(cv.total_conversions, 0)::float / s.total_sessions::float)
            else 0
        end as session_to_conversion_rate

    from campaigns c
    left join session_counts s
        on c.campaign_id = s.campaign_id
    left join conversion_counts cv
        on c.campaign_id = cv.campaign_id
)

select * from final
