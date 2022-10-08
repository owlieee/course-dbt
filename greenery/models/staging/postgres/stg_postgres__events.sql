with source as (

    select * from {{ source('postgres','events') }}

),

renamed as (

    select
        event_id,
        session_id,
        user_id,
        page_url,
        created_at::timestamp as created_at,
        event_type,
        order_id,
        product_id
    from source

)

select * from renamed