with session_aggs as (
    select * from {{ ref('int_session_aggs') }}
)
,

events as (
    select * from {{ ref('int_events') }}
)

select
    events.event_id,
    events.session_id,
    events.user_id,
    events.page_url,
    events.created_at,
    events.event_type,
    events.order_id,
    events.product_id
from events
left join session_aggs 
    on events.session_id = session_aggs.session_id
where session_aggs.has_checkout_events = True