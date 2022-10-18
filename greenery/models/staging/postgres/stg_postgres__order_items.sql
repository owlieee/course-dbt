with source as (

    select * from {{ source('postgres','order_items') }}

),

renamed as (

    select
        concat(order_id, product_id) as order_item_id,
        order_id,
        product_id,
        quantity
    from source

)

select * from renamed