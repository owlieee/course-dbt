with order_items as (
    select * from {{ ref('stg_postgres__order_items') }}
)
,

orders as (
    select * from {{ ref('stg_postgres__orders') }}
)


select  
    order_items.order_item_id,
    order_items.order_id,
    order_items.product_id,
    order_items.quantity,
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
    orders.order_status
from order_items
left join orders
    on order_items.order_id = orders.order_id