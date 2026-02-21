-- Aggregate user-level purchase history for CLV analysis
-- Grain: one row per user who has at least one conversion
-- Upstream: stg_conversions, stg_sessions

with conversions as (
    select * from {{ ref('stg_conversions') }}
),

sessions as (
    select * from {{ ref('stg_sessions') }}
),

user_first_session as (
    select
        user_id,
        channel as acquisition_channel,
        row_number() over (partition by user_id order by session_start asc) as rn
    from sessions
),

acquisition_channels as (
    select
        user_id,
        acquisition_channel
    from user_first_session
    where rn = 1
),

user_metrics as (
    select
        c.user_id,
        min(c.timestamp) as first_purchase_date,
        max(c.timestamp) as last_purchase_date,
        count(distinct c.conversion_id) as total_conversions,
        coalesce(sum(c.conversion_value), 0) as total_revenue,
        coalesce(avg(c.conversion_value), 0) as avg_order_value,
        extract(day from max(c.timestamp) - min(c.timestamp))::int as days_since_first_purchase
    from conversions c
    group by c.user_id
),

final as (
    select
        um.user_id,
        coalesce(ac.acquisition_channel, 'unknown') as acquisition_channel,
        um.first_purchase_date,
        um.last_purchase_date,
        um.total_conversions,
        um.total_revenue,
        um.avg_order_value,
        um.days_since_first_purchase
    from user_metrics um
    left join acquisition_channels ac
        on um.user_id = ac.user_id
)

select * from final
