with source as (
    select * from {{ source('marketing_raw', 'sessions') }}
),

cleaned as (
    select
        session_id,
        date,
        user_id,
        campaign_id,
        creative_id,
        channel,
        session_start,
        session_duration_sec,
        pages_viewed,
        device_type,
        country,

        -- Calculated fields
        case
            when session_duration_sec >= 300 then 'engaged'
            when session_duration_sec >= 60 then 'moderate'
            else 'bounce'
        end as engagement_level,

        case
            when pages_viewed >= 5 then 'high'
            when pages_viewed >= 2 then 'medium'
            else 'low'
        end as page_depth,

        -- Metadata
        year,
        month,
        day

    from source
)

select * from cleaned
