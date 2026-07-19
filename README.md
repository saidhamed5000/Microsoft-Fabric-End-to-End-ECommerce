# 🚀 Microsoft Fabric End-to-End E-Commerce Analytics Platform

<img width="447" height="447" alt="images" src="https://github.com/user-attachments/assets/09e1ed7e-c49c-4f47-873f-4ed4f05f2c2f" />


---
## 📌 Project Overview

Most data analytics projects rely on disjointed tools (like Python, SQL, and Power BI), leading to data silos, complex maintenance, and data duplication. 

This project demonstrates a complete **Enterprise End-to-End Analytics Platform** built entirely on **Microsoft Fabric** to solve these exact challenges. It showcases the true power of a unified data platform by seamlessly integrating:
- **Data Factory** (Data Ingestion & Orchestration)
- **Data Engineering** (Processing with PySpark)
- **Data Warehousing** (Relational Modeling)
- **Business Intelligence** (Power BI & Direct Lake)

By working within a single workspace and utilizing **OneLake**, this solution ensures **Zero Data Duplication**. The data is stored once, and all personas—from Data Engineers to BI Developers—collaborate on the exact same dataset without breaking connections or moving data around.

The solution follows the **Medallion Architecture (Bronze → Silver → Gold)** — taking raw CSV files and transforming them into a fully automated Business Intelligence solution. Built as hands-on preparation for the **DP-600: Implementing Analytics Solutions Using Microsoft Fabric** certification.

---

# Skills Demonstrated

- Data Engineering
- ETL Pipelines
- Data Cleaning
- Data Modeling
- Star Schema Design
- SQL Development
- PySpark
- Power Query
- DAX
- Business Intelligence
- Dashboard Design
- Microsoft Fabric
- Power BI
---
# ⭐ Features

✔ End-to-End Analytics

✔ Microsoft Fabric

✔ Medallion Architecture

✔ OneLake

✔ Lakehouse

✔ PySpark

✔ Delta Tables

✔ Dataflow Gen2

✔ Warehouse

✔ SQL Analytics Endpoint

✔ Direct Lake Semantic Model

✔ Power BI Desktop

✔ Automated Data Pipeline

✔ GitHub Version Control
----
## 🎯 Business Problem

Large e-commerce businesses generate hundreds of thousands of transactions, and raw CSV exports alone cannot answer the questions the business actually needs answered:

- What are the best-selling products and categories?
- Which sellers and states generate the highest revenue?
- Which customers purchase repeatedly, and what drives retention?
- How reliable is delivery performance, and where does it break down?
- Which payment methods dominate, and how do installments behave?

Answering these reliably — and keeping the answers current every day without manual work — requires a proper analytics platform, not a one-off spreadsheet analysis. That's the gap this project closes.

---

## 📦 Dataset

**[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)** — ~1.5M records across 9 relational tables.

| Table | Rows (approx.) | Description |
|---|---|---|
| `customers.csv` | 99,441 | Customer information |
| `orders.csv` | 99,441 | Orders, status, and timestamps |
| `order_items.csv` | 112,650 | Purchased line items |
| `products.csv` | 32,951 | Product catalog |
| `order_payments_dataset.csv` | 103,886 | Payment details |
| `order_reviews.csv` | 99,224 | Customer reviews |
| `sellers.csv` | 3,095 | Seller information |
| `geolocation.csv` | 1,000,163 | Geographic coordinates by zip code |
| `product_category_name_translation.csv` | 71 | Category name translation (PT → EN) |

> Raw CSV files are not included in this repository out of respect for Kaggle's licensing terms. Download them from the link above to reproduce the pipeline.

---

## 🏗 Solution Architecture

```
CSV Files (9 tables)
        │
        ▼
  Lakehouse — Bronze Layer        (raw data, untouched)
        │
        ▼
  PySpark Notebook — Silver Layer (cleaning, typing, feature engineering, Delta Tables)
        │
        ▼
  Dataflow Gen2 — Gold Staging    (merges, business rules, incremental refresh)
        │
        ▼
  Data Warehouse — Star Schema    (Fact & Dimension tables via OneLake Shortcuts)
        │
        ▼
  Semantic Model — Direct Lake    (relationships + DAX measures)
        │
        ▼
  Power BI Reports & Dashboard    (8 pages + executive dashboard)
        │
        ▼
  Data Pipeline — Automation      (scheduled daily refresh, end to end)
```

---

## 🛠 Technology Stack

| Layer | Tool |
|---|---|
| Storage | Microsoft Fabric OneLake |
| Data Ingestion | Fabric Lakehouse |
| Data Engineering | PySpark Notebooks |
| Business Transformation | Dataflow Gen2 (Power Query) |
| Data Warehouse | Fabric Warehouse |
| Query Layer | SQL Endpoint |
| Modeling | Semantic Model (Direct Lake), DAX |<img width="1907" height="862" alt="5" src="https://github.com/user-attachments/assets/21aac59c-0eae-43fa-bccb-4eef831bc6b6" />

| Visualization | Power BI Desktop & Service |
| Orchestration | Data Pipeline |
| Version Control | Git Integration (GitHub) |
| Security | Row-Level Security (RLS) |

---

## 🔄 Project Workflow

**1. Workspace** — `Fabric-EndToEnd-ECommerce` created on Microsoft Fabric.

**2. Lakehouse** — `Sales_Lakehouse` created with folder structure: `Bronze / Silver / Gold / Archive / Scripts / Documentation`.

**3. Bronze Layer** — All 9 raw CSV files uploaded as-is (no transformation).

**4. PySpark Notebook** (`02_Data_Cleaning`) — performed:
- ✔ Reading all 9 CSV files
- ✔ Data profiling (row counts, null checks, duplicate checks) *before* any cleaning
- ✔ Duplicate removal
- ✔ Missing value handling based on root cause, not blanket deletion
- ✔ Data type conversion
- ✔ Feature engineering (delivery days, late-delivery flag, installment buckets, etc.)
- ✔ Saved as Delta Tables

**5. Silver Layer** — 8 cleaned Delta tables: `silver_customers`, `silver_orders`, `silver_order_items`, `silver_products`, `silver_payments`, `silver_reviews`, `silver_sellers`, `silver_geolocation`.

**6. Gold Staging** — Dataflow Gen2 (`DF_Gold_Staging`) merges `order_items` with `products` and `sellers`, adds `RevenuePerItem`, and applies incremental refresh.

**7. Data Warehouse** (`Sales_Warehouse`) — Star Schema with surrogate keys:
- **Dimensions**: `DimCustomer`, `DimProduct`, `DimSeller`, `DimDate`, `DimLocation`
- **Facts**: `FactOrderItems`, `FactPayments`

**8. Semantic Model** (`Sales_SemanticModel`) — relationships across the star schema + DAX measures (sales, time intelligence, customer, delivery, payments).

**9. Power BI** — 8-page interactive report + executive dashboard with pinned KPIs and alerts.

**10. Publish** — Report published to the Fabric workspace, pinned to a dashboard.

**11. Automation** — `PL_Daily_Refresh` pipeline: Notebook → Dataflow → Warehouse refresh → Semantic Model refresh, scheduled daily, with failure notifications.

---

## 🔍 Data Profiling & Engineering Decisions

Every cleaning decision below is based on an **actual profiling pass** over the real dataset (row counts, null checks, duplicate checks via PySpark) — not assumptions.

| Table | Rows | Duplicate Rows | Needs Cleaning? |
|---|---|---|---|
| customers | 99,441 | 0 | No |
| orders | 99,441 | 0 | Yes (nulls) |
| order_items | 112,650 | 0 | No |
| products | 32,951 | 0 | Yes (nulls) |
| order_payments_dataset | 103,886 | 0 | No |
| order_reviews | 99,224 | 0 | Yes (text nulls) |
| sellers | 3,095 | 0 | No |
| geolocation | 1,000,163 | **261,836** | **Yes — highest priority** |
| product_category_name_translation | 71 | 0 | No |

**`geolocation` — the biggest finding in the whole dataset:** 261,836 of 1,000,163 rows (≈26.2%) were exact duplicates. Rather than a blind drop, duplicates were removed and coordinates were aggregated (averaged lat/lng) at the zip-code-prefix level, producing ~19-20K clean location records.

**`orders` — nulls tied to real order status, not bad data:** 160 rows missing `order_approved_at`, 1,783 missing `delivered_carrier_date`, 2,965 missing `delivered_customer_date` — all explained by orders still in transit or cancelled. A `DeliveryStatus` column (`Not Delivered Yet` / `Late` / `On Time`) was derived instead of dropping any row.

**`products` — 610 rows missing category/descriptive data:** Imputed with `"unknown"` rather than dropped, since these products are tied to real transactions in `order_items` and dropping them would silently lose sales history.

**`order_reviews` — 88% missing titles, 59% missing comment text:** Normal customer behavior (star rating without a written comment), handled with placeholder text and a `HasWrittenReview` flag rather than treated as a data quality issue.

**Additional engineering choices:**
- Numeric **surrogate keys** on all dimension tables instead of long text business keys, for warehouse join performance.
- **OneLake Shortcuts** instead of physical copies between Lakehouse and Warehouse (One Copy principle).
- **Incremental Refresh** in Dataflow Gen2 instead of full reloads on every run.

---

## 📊 Star Schema

```

<img width="1907" height="862" alt="5" src="https://github.com/user-attachments/assets/a5d67f6b-dbf0-4672-aa26-ee88cb315bd9" />

                    DimDate
                       │
DimCustomer ── FactOrderItems ── DimProduct
                       │
                  DimSeller

FactOrderItems ── FactPayments   (on order_id)
DimCustomer ── DimLocation       (on zip_code_prefix)
```

---

## 📈 Semantic Model & KPIs

Key DAX measures implemented across the semantic model:

- Total Sales, Total Orders, Average Order Value (AOV)
- Total Customers, Repeat Customer Rate
- Sales YTD / MTD, Sales Growth % (YoY & MoM)
- Average Delivery Days, Late Delivery Rate
- Total Payment Value, Average Installments, % Credit Card Payments
- Average Review Score, % Negative Reviews

---


## ⚙️ Automation Pipeline

```

<img width="1912" height="866" alt="6" src="https://github.com/user-attachments/assets/ca4da589-25c1-45bd-8011-5e7b8b72cd51" />

---

## 📂 Repository Structure

```
Microsoft-Fabric-End-To-End-ECommerce
│
├── README.md
├── architecture-diagram.png
├── notebooks/
│   ├── 01_Data_Exploration.ipynb
│   └── 02_Data_Cleaning.ipynb
├── sql/
│   ├── 01_create_dimensions.sql
│   ├── 02_create_facts.sql
│   ├── 03_foreign_keys.sql
│   └── 04_views.sql
├── dax/
│   └── measures.dax
├── pipeline/
│   └── PL_Daily_Refresh.json
└── screenshots/
    ├── workspace.png
    ├── lakehouse.png
    ├── notebook.png
    ├── dataflow.png
    ├── warehouse.png
    ├── semantic-model.png
    ├── pipeline.png
    └── executive-dashboard.png
```

---

## 📷 Project Screenshots

|---|---|
| **Workspace** | 
| **Lakehouse** | 
| **Notebook** | 
| **Dataflow Gen2** 
| **Warehouse** |
| **Semantic Model
| **Pipeline** |
| **Executive Dashboard** 

<img width="1902" height="851" alt="1" src="https://github.com/user-attachments/assets/70c23dd5-6a5a-42cf-9330-484d0ddecbc7" />
<img width="1912" height="875" alt="2" src="https://github.com/user-attachments/assets/83afa30f-244c-4cb0-b40b-db89e846bb9d" />
<img width="1912" height="870" alt="3" src="https://github.com/user-attachments/assets/8148732c-be75-428f-97b0-75445efae1c7" />
<img width="1901" height="875" alt="4" src="https://github.com/user-attachments/assets/6344fba9-a233-4308-9b3b-3160774c79b6" />
<img width="1907" height="862" alt="5" src="https://github.com/user-attachments/assets/ad5af92d-017d-4d68-b6ca-21955037a872" />
<img width="1912" height="866" alt="6" src="https://github.com/user-attachments/assets/b65b9a76-4a21-4258-b319-a8e7374739a5" />
<img width="1915" height="927" alt="7" src="https://github.com/user-attachments/assets/08fe58dd-bf38-4648-a9fb-7bfb22b57fea" />
<img width="1917" height="902" alt="8" src="https://github.com/user-attachments/assets/23de3161-9d59-4cf5-bd72-04fa9793b446" />
<img width="1915" height="912" alt="9" src="https://github.com/user-attachments/assets/c540e659-7c51-4e4c-8353-c7dfbcc6e033" />

---

## 🚀 Future Enhancements

- Real-Time Intelligence (Eventstream + Eventhouse)
- Data Activator for automated business alerts
- Machine Learning integration (churn prediction, demand forecasting)
- Fabric Deployment Pipelines (Dev → Test → Prod)
- Fabric Mirroring for external database sources
- CI/CD via Azure DevOps

---

## 👨‍💻 Author

**Said Hamed**

🎓 DBA in Finance & Investment
📊 Microsoft Certified: Power BI Data Analyst Associate (PL-300)
💼 Data Analyst | Power BI Developer | Microsoft Fabric Developer

---

## 📬 Contact

- LinkedIn: https://www.linkedin.com/in/said-hamed
- Portfolio: https://saidhamed.my.canva.site/said-hamed-portfolio
- Email: saidhamed5000@gmail.com

---
https://github.com/saidhamed5000/Microsoft-Fabric-End-to-End-ECommerce/blob/main/screenshots/1.png

⭐ If you found this project useful, consider giving it a star.
