with source as (
    select * from {{ source('marketing_raw', 'conversions') }}
),

cleaned as (
    select
        conversion_id,
        session_id,
        date,
        user_id,
        attributed_campaign_id,
        attribution_model,
        conversion_value,
        timestamp,

        -- Calculated fields
        case
            when conversion_value >= 100 then 'high'
            when conversion_value >= 50 then 'medium'
            else 'low'
        end as conversion_value_tier,

        -- Metadata
        year,
        month,
        day

    from source
)

select * from cleaned
