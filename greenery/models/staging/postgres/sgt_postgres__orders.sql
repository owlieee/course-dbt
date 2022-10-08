with source as (

    select * from {{ source('postgres','orders') }}

),

renamed as (

    select
        order_id,
        user_id,
        promo_id,
        address_id,  
        created_at::timestamp as created_at,
        order_cost, --dollars
        shipping_cost,
        order_total,
        tracking_id, 
        shipping_service, 
        estimated_delivery_at::timestamp as estimated_delivery_at,
        delivered_at::timestamp as delivered_at,
        status
    from source

)

select * from renamed