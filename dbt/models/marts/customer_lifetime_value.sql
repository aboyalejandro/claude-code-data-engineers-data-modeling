-- Customer Lifetime Value mart
-- Tracks cumulative spend per user over time, segmented by acquisition channel
-- Grain: one row per user
-- Upstream: int_user_ltv_metrics

with user_ltv as (
    select * from {{ ref('int_user_ltv_metrics') }}
),

final as (
    select
        user_id,
        acquisition_channel,
        first_purchase_date,
        last_purchase_date,
        total_conversions,
        total_revenue,
        avg_order_value,
        days_since_first_purchase,

        -- LTV segmentation
        case
            when total_revenue >= 500 then 'high'
            when total_revenue >= 100 then 'medium'
            else 'low'
        end as ltv_segment

    from user_ltv
)

select * from final
