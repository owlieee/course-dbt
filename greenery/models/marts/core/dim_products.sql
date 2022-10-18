with products as (
    select * from {{ ref('stg_postgres__products')}}
)
,

orders as (
    select * from {{ ref('int_order_item_details')}}
)
,

order_history as (
    select
        product_id,
        count(distinct order_id) as total_orders,
        sum(order_total) as total_revenue,
        sum(quantity) as total_items_sold,
        min(created_at) as ts_first_order,
        max(created_at) as ts_last_order
    from int_order_item_details
    group by 1
)


select
    products.product_id,
    products.product_name,
    products.product_cost,
    products.inventory,
    order_history.total_orders,
    order_history.total_revenue,
    order_history.total_items_sold,
    order_history.ts_first_order,
    order_history.ts_last_order
from products
left join order_history
on products.product_id = order_history.product_id