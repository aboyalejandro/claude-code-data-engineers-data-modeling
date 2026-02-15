with campaign_perf as (
    select * from {{ ref('campaign_performance') }}
),

daily_summary as (
    select
        date,

        -- Campaign metrics
        count(distinct campaign_id) as active_campaigns,
        count(distinct channel) as active_channels,

        -- Spend metrics
        sum(spend) as total_spend,
        sum(daily_budget) as total_budget,
        sum(spend) / nullif(sum(daily_budget), 0) as budget_utilization,

        -- Impression & Click metrics
        sum(impressions) as total_impressions,
        sum(clicks) as total_clicks,
        avg(ctr) as avg_ctr,
        avg(cpc) as avg_cpc,

        -- Session metrics
        sum(total_sessions) as total_sessions,
        sum(unique_users) as total_users,
        avg(avg_session_duration) as avg_session_duration,
        avg(avg_pages_per_session) as avg_pages_per_session,

        -- Conversion metrics
        sum(total_conversions) as total_conversions,
        sum(total_revenue) as total_revenue,
        avg(avg_order_value) as avg_order_value,

        -- Calculated metrics
        sum(total_conversions)::float / nullif(sum(total_sessions), 0) as overall_conversion_rate,
        sum(total_revenue) / nullif(sum(spend), 0) as overall_roas,
        sum(spend) / nullif(sum(total_conversions), 0) as overall_cpa

    from campaign_perf
    group by date
)

select * from daily_summary
order by date desc
