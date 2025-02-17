with events as (
    select * from {{ ref('stg_postgres__events')}}
)

select
    event_id,
    session_id,
    user_id,
    page_url,
    created_at,
    event_type,
    order_id,
    product_id
from events