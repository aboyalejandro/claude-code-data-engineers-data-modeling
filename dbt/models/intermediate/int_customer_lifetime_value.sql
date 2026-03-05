with conversions as (
    select * from {{ ref('stg_conversions') }}
),

customer_metrics as (
    select
        user_id,
        sum(conversion_value) as total_revenue,
        count(distinct conversion_id) as total_orders,
        min(date) as first_purchase_date,
        max(date) as last_purchase_date

    from conversions
    group by user_id
)

select * from customer_metrics
