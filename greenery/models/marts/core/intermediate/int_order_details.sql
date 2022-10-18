with orders as (
    select * from {{ ref('stg_postgres__orders') }}
)
,

order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
)
,

promos as (
    select * from {{ ref('stg_postgres__promos') }}
)
,

item_counts as (
    select
        order_id,
        count(distinct product_id) as total_distinct_products,
        sum(quantity) as total_items
    from order_items
    group by 1
)

select    
    orders.order_id,
    orders.user_id,
    orders.promo_id,
    orders.address_id,  
    orders.tracking_id, 
    orders.created_at,
    orders.estimated_delivery_at,
    orders.delivered_at,
    orders.order_cost, 
    orders.shipping_cost,
    orders.order_total,
    orders.shipping_service, 
    orders.order_status,
    item_counts.total_distinct_products,
    item_counts.total_items,
    promos.discount
from orders 
left join item_counts
    on orders.order_id = item_counts.order_id
left join promos 
    on orders.promo_id = promos.promo_id