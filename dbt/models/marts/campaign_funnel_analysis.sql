with funnel as (
    select * from {{ ref('int_campaign_funnel') }}
),

campaign_details as (
    select distinct
        campaign_id,
        campaign_name,
        channel

    from {{ ref('stg_campaigns_daily') }}
),

final as (
    select
        f.campaign_id,
        cd.campaign_name,
        cd.channel,

        -- Funnel counts
        f.total_impressions,
        f.total_clicks,
        f.total_sessions,
        f.total_conversions,
        f.total_revenue,

        -- Stage-to-stage conversion rates
        case
            when f.total_impressions > 0 then (f.total_clicks::float / f.total_impressions::float)
            else 0
        end as impression_to_click_rate,

        case
            when f.total_clicks > 0 then (f.total_sessions::float / f.total_clicks::float)
            else 0
        end as click_to_session_rate,

        case
            when f.total_sessions > 0 then (f.total_conversions::float / f.total_sessions::float)
            else 0
        end as session_to_conversion_rate,

        -- Overall efficiency score
        case
            when f.total_impressions > 0 then (f.total_conversions::float / f.total_impressions::float)
            else 0
        end as efficiency_score

    from funnel f
    left join campaign_details cd
        on f.campaign_id = cd.campaign_id
)

select * from final
