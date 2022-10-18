## Week 2

### Part 1- Models

#### What is our user repeat rate?
##### Repeat Rate = Users who purchased 2 or more times / users who purchased

```
with repeat_count as (
    select 
        user_id,
        count(*) as count_orders
    from stg_postgres__orders 
    group by 1
)

select 
    count(distinct iff(count_orders>1, user_id, null))/count(distinct user_id) as repeat_rate
from repeat_count
```

Overall the repeat rate is 79.8%.

#### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Some of these areas would be interesting to explore as indicators for both repeat and non-repeat purchases:
- Order return- given a fixed return window, did they end up keeping their orders
- Qualitative satisfaction (user surveys, reviews, customer support interactions etc.)
- Returning for sessions after receiving first order 
- If promo codes include user referral codes-- did they refer friends?
- Email open rate
We could also look into correlating behavioral data (add to cart, session duration, logins) with repeat purchases. 

#### Explain the marts models you added. Why did you organize the models in the way you did?
I added most of my models to core to start. I created a dimensional table for products and users that includes some aggregate information for easier querying. The intermediate models in core include some joins of orders and order items so that it's easier to aggregate by the needed id (product, user, etc). 

Not having had stakeholder conversations, I didn't add much to marketing or product. I imagined that marketing might care about some promo usage information and product might be interested in querying events that are part of specific types of sessions. 

### Part 2- Tests
I did not spend much time here. For now, the tests are just for uniqueness and null on the main ids. I will revisit tests this week.

I would run the tests after each dbt run to make sure that we caught and communicated errors early.

### Part 3- Snapshots

#### Which orders changed from week 1 to week 2? 

```
select * 
from snapshot__orders
where order_id in (
    select order_id from snapshot__orders where dbt_valid_to is not null
)
order by order_id, dbt_updated_at
```

3 orders that were preparing to ship have shipped!
05202733-0e17-4726-97c2-0520c024ab85
914b8929-e04a-40f8-86ee-357f2be3a2a2
939767ac-357a-4gibec-91f8-a7b25edd46c9