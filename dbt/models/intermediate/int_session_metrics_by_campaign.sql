-- Aggregate session metrics by campaign and date
-- This intermediate model is used by campaign_performance

with sessions as (
    select * from {{ ref('stg_sessions') }}
)

select
    campaign_id,
    date,
    count(distinct session_id) as total_sessions,
    count(distinct user_id) as unique_users,
    avg(session_duration_sec) as avg_session_duration,
    avg(pages_viewed) as avg_pages_per_session,
    sum(case when engagement_level = 'engaged' then 1 else 0 end) as engaged_sessions,
    sum(case when device_type = 'mobile' then 1 else 0 end) as mobile_sessions,
    sum(case when device_type = 'desktop' then 1 else 0 end) as desktop_sessions
from sessions
group by campaign_id, date
