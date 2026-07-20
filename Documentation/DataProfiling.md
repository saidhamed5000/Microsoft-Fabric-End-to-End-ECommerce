# Data Profiling Summary

Results of the profiling pass performed in `Notebook/01_Data_Exploration.ipynb`, before any cleaning was applied. All numbers come from `df.count()`, per-column null counts, and `dropDuplicates()` comparisons executed in PySpark against the raw Bronze tables.

---

## Row & Column Counts (Bronze)

| Table | Rows | Columns |
|---|---|---|
| customers | 99,441 | 5 |
| orders | 99,441 | 8 |
| order_items | 112,650 | 7 |
| products | 32,951 | 9 |
| order_payments_dataset | 103,886 | 5 |
| order_reviews | 99,224 | 7 |
| sellers | 3,095 | 4 |
| geolocation | 1,000,163 | 5 |
| product_category_name_translation | 71 | 2 |

---

## Null Value Findings

| Table | Column(s) with Nulls | Approx. Null Count | Root Cause |
|---|---|---|---|
| orders | order_approved_at | 160 | Payment not yet approved / order canceled |
| orders | order_delivered_carrier_date | 1,783 | Order not yet handed to carrier |
| orders | order_delivered_customer_date | 2,965 | Order still in transit or canceled |
| products | product_category_name and descriptive fields | 610 | Missing catalog metadata at source |
| order_reviews | review_comment_title | ~87,656 (≈88%) | Customer rated without adding a title |
| order_reviews | review_comment_message | ~58,247 (≈59%) | Customer rated without adding a comment |

All other tables (`customers`, `order_items`, `order_payments_dataset`, `sellers`, `geolocation`, `product_category_name_translation`) returned **zero nulls** on their key columns.

---

## Duplicate Record Findings

| Table | Total Rows | Unique Rows | Duplicates | % Duplicate |
|---|---|---|---|---|
| customers | 99,441 | 99,441 | 0 | 0% |
| orders | 99,441 | 99,441 | 0 | 0% |
| order_items | 112,650 | 112,650 | 0 | 0% |
| products | 32,951 | 32,951 | 0 | 0% |
| order_payments_dataset | 103,886 | 103,886 | 0 | 0% |
| order_reviews | 99,224 | 99,224 | 0 | 0% |
| sellers | 3,095 | 3,095 | 0 | 0% |
| **geolocation** | **1,000,163** | **738,327** | **261,836** | **≈26.2%** |
| product_category_name_translation | 71 | 71 | 0 | 0% |

**Key finding:** `geolocation` is the only table with meaningful duplication, and it is severe — roughly 1 in 4 rows was an exact duplicate. This is expected for the dataset: the same zip-code prefix can have many recorded lat/lng pings from different deliveries.

---

## Cleaning Decisions Driven by This Profiling

1. **geolocation** — Deduplicated, then aggregated (average lat/lng, first city/state) by `geolocation_zip_code_prefix`, reducing ~1,000,163 raw rows to roughly 19,000–20,000 clean location records.
2. **orders** — Nulls were not dropped. They reflect real order lifecycle states, so a derived `DeliveryStatus` column (`Not Delivered Yet` / `Late` / `On Time`) was added instead.
3. **products** — Missing category/descriptive fields were imputed (`"unknown"` / `0`) rather than dropped, since these products are tied to real transactions in `order_items`.
4. **order_reviews** — Missing titles/comments were replaced with placeholder text (`"No Title"` / `"No Comment"`), and a `HasWrittenReview` flag was derived to preserve the signal for reporting.

---

## Post-Cleaning Verification (Silver Layer)

| Silver Table | Expected Row Count |
|---|---|
| silver_customers | 99,441 |
| silver_orders | 99,441 |
| silver_order_items | 112,650 |
| silver_products | 32,951 |
| silver_payments | 103,886 |
| silver_reviews | 99,224 |
| silver_sellers | 3,095 |
| silver_geolocation | ~19,000–20,000 |
