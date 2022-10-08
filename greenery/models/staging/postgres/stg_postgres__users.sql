with source as (

    select * from {{ source('postgres','users') }}

),

renamed as (

    select
        user_id,
        first_name,
        last_name,
        email,
        phone_number,
        created_at::timestamp as created_at,
        updated_at::timestamp as updated_at,
        address_id
    from source

)

select * from renamed