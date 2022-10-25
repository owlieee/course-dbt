
with fct_checkout_session_events as (
    select * from {{ ref('fct_checkout_session_events') }}
)
,

fct_page_view_session_events as (
    select * from {{ ref('fct_page_view_session_events') }}
)
,

dim_products as (
    select * from {{ ref('dim_products') }}
)
,

page_view_sessions_per_product as (
    select 
        product_id,
        count(distinct session_id) as count_page_view_sessions
    from fct_page_view_session_events
    group by product_id
)
,

checkout_sessions_per_product as (
    select 
        product_id,
        count(distinct session_id) as count_checkout_sessions
    from fct_checkout_session_events
    group by product_id
)

select 
    dim_products.product_id,
    dim_products.product_name,
    zeroifnull(count_checkout_sessions)/count_page_view_sessions as conversion_rate
from dim_products
left join page_view_sessions_per_product
    on dim_products.product_id = page_view_sessions_per_product.product_id
left join checkout_sessions_per_product 
    on page_view_sessions_per_product.product_id = checkout_sessions_per_product.product_id
order by 3 desc