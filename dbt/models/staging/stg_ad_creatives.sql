with source as (
    select * from {{ source('marketing_raw', 'ad_creatives') }}
),

cleaned as (
    select
        creative_id,
        campaign_id,
        creative_type,
        creative_name,
        impressions,
        clicks,
        ctr,
        spend,

        -- Calculated fields
        case
            when impressions > 0 then (clicks::float / impressions::float)
            else 0
        end as calculated_ctr

    from source
)

select * from cleaned
