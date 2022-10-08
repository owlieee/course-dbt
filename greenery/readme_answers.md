## Week 1

### How many users do we have? 

``` 
select 
    count(distinct user_id)
from stg_postgres__users
```

130

### On average, how many orders do we receive per hour?

```
with orders_per_hour as (
    select 
        date_trunc('hour', created_at) as date_hour, 
        count(*) as c 
    from stg_postgres__orders
    group by 1
    order by 1
)

select 
    avg(c) as average_orders,
    -- data quality check: no 0 order hours in date range
    count(distinct date_hour) as total_hours, 
    datediff('hour', min(date_hour), max(date_hour)) as hours_in_data
from orders_per_hour
```

7.5


### On average, how long does an order take from being placed to being delivered?

```
with customer_wait_days as (
    select 
        datediff('day', created_at, delivered_at) as customer_wait_days
    from stg_postgres__orders
    where delivered_at is not null
)

select 
    avg(customer_wait_days) as avg_customer_wait_days
from customer_wait_days
```

Almost 4 days (3.9)

### How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

```
with orders_per_user as (
    select 
        user_id, 
        count(distinct order_id) as total_orders,
        case 
            when total_orders <= 2 then total_orders::string
            else '3+'
        end as number_of_orders
    from stg_postgres__orders 
    group by 1
)

select 
    number_of_orders,
    count(distinct user_id) as count_users
from orders_per_user 
group by 1
```

1: 25 users
2: 28 users
3+: 71 users

### On average, how many unique sessions do we have per hour?

```
with sessions_per_hour as (
    select 
        date_trunc('hour', created_at) as date_hour, 
        count(distinct session_id) as c 
    from stg_postgres__events
    group by 1
    order by 1
)

select 
    avg(c) as average_sessions,
    -- data quality check: no 0 order hours in date range
    count(distinct date_hour) as total_hours, 
    datediff('hour', min(date_hour), max(date_hour)) as hours_in_data
from sessions_per_hour
```
16-- big outlier, 240 one hour