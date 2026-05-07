with monthly_sales as (
    select
        date_trunc('month', h.order_date)::date as order_month,
        sum(d.order_qty * d.unit_price)         as total_monthly_sales
    from production.sales_order_detail as d
    join production.sales_order_header as h
        on d.sales_order_id = h.sales_order_id
    group by date_trunc('month', h.order_date)::date
)

select
    order_month,
    total_monthly_sales,
    case
        when count(*) over (
            order by order_month
            rows between 2 preceding and current row
        ) = 3
        then avg(total_monthly_sales) over (
            order by order_month
            rows between 2 preceding and current row
        )
        else null
    end as three_month_rolling_avg
from monthly_sales
order by order_month
