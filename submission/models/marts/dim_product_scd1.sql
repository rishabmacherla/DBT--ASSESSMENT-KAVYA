/*
  Task 2 — Delete behavior (Requirement 10):
  When a row is deleted from the source (production.product), an incremental model
  does NOT remove it from dim_product_scd1. On the next dbt run, the incremental
  filter only processes rows where date_modified is newer than the current max —
  so the deleted row is simply never touched and stays in the table indefinitely.

  What SHOULD happen (SCD Type 1): the record should disappear to reflect the
  current state of the source. To handle this correctly you would need either:
    a) A full-refresh run (`dbt run --full-refresh`) to rebuild the table from scratch, or
    b) An incremental strategy that explicitly deletes records not present in the source
       (e.g. using a post-hook DELETE or the dbt `delete+insert` strategy with a
       predicate that covers all active rows).
*/

{{
    config(
        materialized='incremental',
        unique_key='product_key',
        tags=['product']
    )
}}

select
    {{ dbt_utils.generate_surrogate_key(['p.product_id']) }} as product_key,
    p.product_id,
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

{% if is_incremental() %}
where p.date_modified > (select max(date_modified) from {{ this }})
{% endif %}
