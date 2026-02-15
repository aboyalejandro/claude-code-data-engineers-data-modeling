with source as (
    select * from {{ source('marketing_raw', 'campaigns_daily') }}
),

cleaned as (
    select
        campaign_id,
        date,
        campaign_name,
        channel,
        status,
        daily_budget,
        spend,
        impressions,
        clicks,
        ctr,
        cpc,

        -- Calculated fields
        case
            when impressions > 0 then (clicks::float / impressions::float)
            else 0
        end as calculated_ctr,

        case
            when clicks > 0 then (spend / clicks)
            else 0
        end as calculated_cpc,

        -- Metadata
        year,
        month,
        day

    from source
)

select * from cleaned
