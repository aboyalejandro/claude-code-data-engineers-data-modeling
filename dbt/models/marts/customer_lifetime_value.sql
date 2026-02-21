with customer_metrics as (
    select * from {{ ref('int_customer_lifetime_value') }}
),

first_touch_ranked as (
    select
        user_id,
        channel as acquisition_channel,
        row_number() over (partition by user_id order by timestamp asc) as rn

    from {{ ref('stg_attribution_touchpoints') }}
    where touchpoint_position = 1
),

first_touch as (
    select
        user_id,
        acquisition_channel

    from first_touch_ranked
    where rn = 1
),

final as (
    select
        cm.user_id,
        cm.total_revenue,
        cm.total_orders,
        cm.first_purchase_date,
        cm.last_purchase_date,
        coalesce(ft.acquisition_channel, 'unknown') as acquisition_channel,

        case
            when cm.total_revenue >= 500 then 'high'
            when cm.total_revenue >= 100 then 'medium'
            else 'low'
        end as ltv_tier

    from customer_metrics cm
    left join first_touch ft
        on cm.user_id = ft.user_id
)

select * from final
