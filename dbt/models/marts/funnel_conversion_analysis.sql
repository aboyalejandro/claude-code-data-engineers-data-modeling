-- Funnel Conversion Analysis mart
-- Tracks the funnel from impression -> click -> session -> conversion per campaign/channel
-- Grain: one row per campaign
-- Upstream: int_funnel_stages_by_campaign

with funnel_stages as (
    select * from {{ ref('int_funnel_stages_by_campaign') }}
),

final as (
    select
        campaign_id,
        campaign_name,
        channel,
        total_impressions,
        total_clicks,
        total_sessions,
        total_conversions,
        click_through_rate,
        click_to_session_rate,
        session_to_conversion_rate,

        -- Overall funnel efficiency: conversions / impressions
        case
            when total_impressions > 0 then (total_conversions::float / total_impressions::float)
            else 0
        end as overall_funnel_efficiency,

        -- Funnel efficiency score: percentile ranking across all campaigns
        percent_rank() over (
            order by case
                when total_impressions > 0 then (total_conversions::float / total_impressions::float)
                else 0
            end
        ) as funnel_efficiency_score

    from funnel_stages
)

select * from final
