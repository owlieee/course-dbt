with promos as (
    select * from {{ ref('stg_postgres__promos') }}
)
, 

order_details as (
    select * from {{ ref('int_order_details') }}
)


select 
    promos.promo_id,
    promos.discount,
    promos.promo_status,
    count(distinct order_id) as total_orders_with_promo
from promos
left join order_details
    on promos.promo_id = order_details.promo_id
group by 1, 2, 3

