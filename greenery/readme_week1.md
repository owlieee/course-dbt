## Week 1

### How many users do we have? 

``` 
select 
    count(distinct user_id)
from stg_postgres__users
```

130 distinct users

### On average, how many orders do we receive per hour?

```
with orders_per_hour as (
    select 
        date_trunc('hour', created_at) as date_hour, 
        count(*) as count_orders
    from stg_postgres__orders
    group by 1
    order by 1
)

select 
    avg(count_orders) as average_orders,
    -- data quality checks: no 0 order hours in date range
    count(distinct date_hour) as total_hours, 
    datediff('hour', min(date_hour), max(date_hour)) as hours_in_data,
    min(date_hour),
    max(date_hour)
from orders_per_hour
```

With the caveat that we only have 2 complete days of data (2021/2/10-2021-2/11), we receive on average 7.5 orders per hour.


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

From the 305 delivered orders between 2021/2/10-2021/2/11, orders are delivered nearly 4 days (3.9) from order date. 

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

- 1: 25 users
- 2: 28 users
- 3+: 71 users

### On average, how many unique sessions do we have per hour?

```
with sessions_per_hour as (
    select 
        date_trunc('hour', created_at) as date_hour, 
        count(distinct session_id) as count_sessions 
    from stg_postgres__events
    group by 1
    order by 1
)

select 
    avg(count_sessions) as average_sessions,
    -- data quality check: no 0 order hours in date range
    count(distinct date_hour) as total_hours, 
    datediff('hour', min(date_hour), max(date_hour)) as hours_in_data
from sessions_per_hour
```

Looking at all the data available, we average about 16 sessions per hour. There is one big outlier hour that has 240 sesssions-- unknown business context, but it does skew the average high, especially with only 58 hours of data represented. 