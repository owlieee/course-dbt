
with int_session_aggs as (
    select * from {{ ref('int_session_aggs') }}
)

select 
    count(distinct iff(has_checkout_events, session_id, null))/count(distinct session_id) as conversion_rate
from int_session_aggs
