# DBT Hands-On Assessment

**Note:** The source and target connection to postgres is already configured.
- dbt deps might need to be run
- python .venv should be configured

The tables you will be using in postgres are in the AdventureWorks database, production and mart schemas. They were loaded from the seeds/

## Some starter queries:

1. `select * from production.product;`
2. `select * from production.product_category;`
3. `select * from production.product_subcategory;`

---

## Task 1

**Build a SCD Type-2 snapshot for the product dimension in dbt that tracks changes and keeps history.**

The table should be written to the mart schema.

**Model name:**
1. `snapshots/dim_product_scd2.sql`

**Sources:**
1. product
2. product_category
3. product_subcategory

**Requirements:**
1. Build a SCD Type 2 model to track changes in the product attributes over time.
2. Generate a surrogate key.
3. Detect changes using the check strategy.
4. Include the following columns for change detection: `product_name`, `product_number`, `color`, `list_price`, `product_category_name`, and `product_subcategory_name`
5. Update data in production and verify that history is tracked in the dim_product_scd2

---

## Task 2

**Build a SCD Type-1 dbt model using incremental materialization.** Use the same data mapping document from Task 1.

**Model name:**
2. `marts/dim_product_scd1.sql`

**Sources:**
4. product
5. product_category
6. product_subcategory

**Requirements:**
6. Build a SCD Type 1 model.
7. Generate a surrogate key.
8. Implement incremental materialization.
9. Update data in production and verify that the changes comes through
10. Delete a row of data in production. What happens? What should happen?

   **Write a brief answer, you can speak to it later.**

---

## Task 3

**Add data tests for the below columns:**

- `product_key` - not_null, unique
- `product_id` - not_null

---

## Task 4

**Add a common tag like "product" to the dim_product_scd1 model, create a selector, and run using the selector**

---

## SQL Queries

### Task 5

Use the sales and product data to answer the question at the end:

```sql
select * from production.sales_order_header;
select * from production.sales_order_detail;

-- order details
select h.sales_order_id,
       P.product_id,
       p.name,
       Order_qty * unit_price as order_line_sales,
       h.Order_Date
  from production.sales_order_detail as d
  join production.sales_order_header as h
    on d.sales_order_id = h.sales_order_id
  join production.product as p
    on d.product_id = p.product_id;

-- how many orders per month?
select DATE_TRUNC('month', Order_Date)::date, count(*)
  from production.sales_order_header
group by DATE_TRUNC('month', Order_Date)::date
order by 1;
```

**Write SQL to calculate the 3-month rolling average of total monthly sales, ensuring that the average is returned as NULL unless a full three months of data is available for the calculation.**

Your output should match this format (showing first 8 months):

| order_month | total_monthly_sales | three_month_rolling_avg |
|-------------|---------------------|------------------------|
| 2011-05-01  | 503805.9169         | [null]                 |
| 2011-06-01  | 458910.8248         | [null]                 |
| 2011-07-01  | 2046265.0860        | 1002994                |
| 2011-08-01  | 2496365.0124        | 1667180                |
| 2011-09-01  | 502073.8458         | 1681568                |
| 2011-10-01  | 4590874.8687        | 2529771                |
| 2011-11-01  | 737839.8214         | 1943596                |
| 2011-12-01  | 1196286.5645        | 2175000                |

**Notes:**
- First two rows must have NULL (not enough data for 3-month average)
- Starting from row 3, calculate average of current month + previous 2 months
- All numeric values should be fully displayed (no truncation)

**To run SQL queries:**
```bash
# From the dbt/ directory, use the query helper:
python query.py "SELECT * FROM production.product LIMIT 5"

# Or run from a SQL file:
python query.py -f task5_solution.sql

# Save your final query to: task5_solution.sql
```



## Submission

### What to Submit

Your submission should include:
- `snapshots/dim_product_scd2.sql` (Task 1)
- `models/marts/dim_product_scd1.sql` (Task 2)
- `tests/` directory with your data tests (Task 3)
- `selectors.yml` (Task 4)
- `task5_solution.sql` (Task 5)

### How to Submit

```bash
# From the dbt/ directory, create a ZIP file
zip -r ../submission.zip . -x "*.duckdb" -x "*.duckdb.wal" -x "target/*" -x "dbt_packages/*" -x "logs/*" -x ".venv/*"

# Windows PowerShell:
# Compress-Archive -Path * -DestinationPath ..\submission.zip -Exclude *.duckdb,target,dbt_packages,logs,.venv
```

The submission ZIP should be in the parent directory: `../submission.zip`

---

**Good luck!** 
