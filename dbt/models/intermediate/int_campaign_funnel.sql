with campaigns as (
    select * from {{ ref('stg_campaigns_daily') }}
),

campaign_totals as (
    select
        campaign_id,
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks

    from campaigns
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
        count(distinct conversion_id) as total_conversions,
        sum(conversion_value) as total_revenue

    from {{ ref('stg_conversions') }}
    group by attributed_campaign_id
),

final as (
    select
        ct.campaign_id,
        ct.total_impressions,
        ct.total_clicks,
        coalesce(sc.total_sessions, 0) as total_sessions,
        coalesce(cc.total_conversions, 0) as total_conversions,
        coalesce(cc.total_revenue, 0) as total_revenue

    from campaign_totals ct
    left join session_counts sc
        on ct.campaign_id = sc.campaign_id
    left join conversion_counts cc
        on ct.campaign_id = cc.campaign_id
)

select * from final
