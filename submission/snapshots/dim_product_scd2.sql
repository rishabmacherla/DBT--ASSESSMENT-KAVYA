{% snapshot dim_product_scd2 %}

{{
    config(
        target_schema='mart',
        unique_key='product_id',
        strategy='check',
        check_cols=[
            'product_name',
            'product_number',
            'color',
            'list_price',
            'product_category_name',
            'product_subcategory_name'
        ]
    )
}}

select
    p.product_id,
    {{ dbt_utils.generate_surrogate_key(['p.product_id']) }} as product_key,
    p.name                as product_name,
    p.product_number,
    p.color,
    p.list_price,
    pc.name               as product_category_name,
    ps.name               as product_subcategory_name,
    p.date_modified
from {{ ref('product') }} as p
left join {{ ref('product_subcategory') }} as ps
    on p.product_subcategory_id = ps.product_subcategory_id
left join {{ ref('product_category') }} as pc
    on ps.product_category_id = pc.product_category_id

{% endsnapshot %}
