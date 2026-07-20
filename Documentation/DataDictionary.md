# Data Dictionary

Column-level reference for every table in the Silver layer and the Warehouse star schema.

---

## Silver Layer

### silver_customers

| Column | Type | Description |
|---|---|---|
| customer_id | string | Unique key per order (a customer gets a new ID per order) |
| customer_unique_id | string | Stable identifier for the actual customer across orders |
| customer_zip_code_prefix | integer | First digits of the customer's zip code |
| customer_city | string | Customer city, title-cased |
| customer_state | string | Customer state, 2-letter code, upper-cased |

### silver_orders

| Column | Type | Description |
|---|---|---|
| order_id | string | Unique order identifier |
| customer_id | string | Foreign key to silver_customers |
| order_status | string | Order status (delivered, shipped, canceled, etc.) |
| order_purchase_timestamp | timestamp | When the order was placed |
| order_approved_at | timestamp | When payment was approved |
| order_delivered_carrier_date | timestamp | When the order was handed to the logistics partner |
| order_delivered_customer_date | timestamp | When the order reached the customer |
| order_estimated_delivery_date | timestamp | Estimated delivery date shown to the customer |
| OrderYear / OrderMonth / OrderDay | integer | Derived calendar parts |
| MonthName / WeekDay | string | Derived calendar labels |
| Quarter | integer | Derived calendar quarter |
| DeliveryDays | integer | Days between purchase and delivery |
| LateDeliveryDays | integer | Days delivered after the estimated date (negative = early) |
| DeliveryStatus | string | Derived: "On Time" / "Late" / "Not Delivered Yet" |

### silver_order_items

| Column | Type | Description |
|---|---|---|
| order_id | string | Foreign key to silver_orders |
| order_item_id | integer | Line item sequence number within the order |
| product_id | string | Foreign key to silver_products |
| seller_id | string | Foreign key to silver_sellers |
| price | double | Item price |
| freight_value | double | Shipping cost for the item |
| TotalValue | double | Derived: price + freight_value |

### silver_products

| Column | Type | Description |
|---|---|---|
| product_id | string | Unique product identifier |
| product_category_name | string | Original category name (Portuguese) |
| product_category_name_english | string | Translated category name; "Unknown" if no translation exists |
| product_name_lenght | double | Character length of the product name |
| product_description_lenght | double | Character length of the product description |
| product_photos_qty | double | Number of product photos |
| product_weight_g | double | Product weight in grams |
| product_length_cm / product_height_cm / product_width_cm | double | Product dimensions in cm |

### silver_payments

| Column | Type | Description |
|---|---|---|
| order_id | string | Foreign key to silver_orders |
| payment_sequential | integer | Sequence number if multiple payment methods were used |
| payment_type | string | Payment method (credit_card, boleto, voucher, debit_card) |
| payment_installments | integer | Number of installments |
| payment_value | double | Amount paid |
| InstallmentBucket | string | Derived: "Single Payment" / "2-6 Installments" / "7+ Installments" |

### silver_reviews

| Column | Type | Description |
|---|---|---|
| review_id | string | Unique review identifier |
| order_id | string | Foreign key to silver_orders |
| review_score | integer | Star rating (1-5) |
| review_comment_title | string | Review title; "No Title" if not provided |
| review_comment_message | string | Review text; "No Comment" if not provided |
| HasWrittenReview | boolean | Derived: true if the customer left written text |

### silver_sellers

| Column | Type | Description |
|---|---|---|
| seller_id | string | Unique seller identifier |
| seller_zip_code_prefix | integer | First digits of the seller's zip code |
| seller_city | string | Seller city, title-cased |
| seller_state | string | Seller state, 2-letter code, upper-cased |

### silver_geolocation

| Column | Type | Description |
|---|---|---|
| geolocation_zip_code_prefix | integer | Zip code prefix (grouping key) |
| lat | double | Average latitude for the zip prefix |
| lng | double | Average longitude for the zip prefix |
| city | string | City name for the zip prefix |
| state | string | State code for the zip prefix |

---

## Warehouse Star Schema

### DimCustomer
customer_key (PK, surrogate) · customer_id · customer_unique_id · customer_zip_code_prefix · customer_city · customer_state

### DimProduct
product_key (PK, surrogate) · product_id · product_category_name_english · product_weight_g · product_length_cm · product_height_cm · product_width_cm

### DimSeller
seller_key (PK, surrogate) · seller_id · seller_city · seller_state · seller_zip_code_prefix

### DimDate
date_key (PK, yyyyMMdd int) · full_date · day · month · month_name · quarter · year · is_weekend

### DimLocation
zip_prefix (PK) · lat · lng · city · state

### FactOrderItems
order_id · order_item_id · customer_key (FK) · product_key (FK) · seller_key (FK) · date_key (FK) · price · freight_value · revenue

### FactPayments
order_id (FK, logical) · payment_sequential · payment_type · payment_installments · payment_value
