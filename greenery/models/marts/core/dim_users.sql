with users as (
    select * from {{ ref('stg_postgres__users')}}
)
,

orders as (
    select * from {{ ref('int_order_details')}}
)
,

order_history as (
    select
        user_id,
        count(*) as total_orders,
        sum(order_total) as total_spend,
        sum(total_items) as total_items,
        min(created_at) as ts_first_order,
        max(created_at) as ts_last_order
    from int_order_details
    group by 1
)

select
    users.user_id,
    users.first_name,
    users.last_name,
    users.email,
    users.phone_number,
    users.created_at,
    users.updated_at,
    users.address_id,
    zeroifnull(order_history.total_orders) as total_orders,
    zeroifnull(order_history.total_spend) as total_spend,
    zeroifnull(order_history.total_items) as total_items,
    total_orders > 1 as is_repeat_customer,
    order_history.ts_first_order,
    order_history.ts_last_order
from users 
left join order_history
on users.user_id = order_history.user_id