with source as (

    select * from {{ source('postgres','orders') }}

),

renamed as (

    select
        --ids
        order_id,
        user_id,
        promo_id,
        address_id,  
        tracking_id, 

        --timestamps
        created_at,
        estimated_delivery_at,
        delivered_at,

        --costs in dollars
        order_cost, 
        shipping_cost,
        order_total,
        
        --strings
        shipping_service, 
        status as order_status
    from source

)

select * from renamed