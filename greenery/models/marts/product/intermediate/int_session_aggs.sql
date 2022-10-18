with events as (
    select * from {{ ref('int_events') }}
)

select
    session_id,
    sum(iff(event_type = 'page_view', 1, 0)) as total_page_view_events,
    sum(iff(event_type = 'add_to_cart', 1, 0)) as total_add_to_cart_events,
    sum(iff(event_type = 'checkout', 1, 0)) as total_checkout_events,
    total_page_view_events > 0 as has_page_view_events,
    total_add_to_cart_events > 0 as has_add_to_cart_events,
    total_checkout_events > 0 as has_checkout_events
from events
group by 1