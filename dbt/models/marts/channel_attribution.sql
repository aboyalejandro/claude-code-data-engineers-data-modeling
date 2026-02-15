-- Simplified mart model using intermediate models for attribution calculations

with channel_attribution as (
    select * from {{ ref('int_channel_attribution_calc') }}
),

final as (
    select
        channel,
        count(distinct conversion_id) as attributed_conversions,

        -- First-touch attribution
        sum(first_touch_value) as first_touch_revenue,
        count(distinct case when first_touch_value > 0 then conversion_id end) as first_touch_conversions,

        -- Last-touch attribution
        sum(last_touch_value) as last_touch_revenue,
        count(distinct case when last_touch_value > 0 then conversion_id end) as last_touch_conversions,

        -- Linear attribution
        sum(linear_value) as linear_revenue

    from channel_attribution
    group by channel
)

select * from final
