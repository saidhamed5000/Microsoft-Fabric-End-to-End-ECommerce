# 🚀 Microsoft Fabric End-to-End E-Commerce Analytics Platform

<p align="center">

![Fabric](https://img.shields.io/badge/Microsoft-Fabric-742774?style=for-the-badge)
![Power BI](https://img.shields.io/badge/Power-BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![PySpark](https://img.shields.io/badge/PySpark-E25A1C?style=for-the-badge&logo=apachespark&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![DP-600](https://img.shields.io/badge/Prep-DP--600-0078D4?style=for-the-badge)

</p>

---

## 📌 Project Overview

This project demonstrates a complete **Enterprise End-to-End Analytics Platform** built entirely on **Microsoft Fabric** — from raw CSV files to a fully automated Business Intelligence solution.

The solution follows the **Medallion Architecture (Bronze → Silver → Gold)** and integrates Fabric's core services: Lakehouse, PySpark Notebooks, Dataflow Gen2, Data Warehouse, Semantic Model, Power BI, and Data Pipeline orchestration.

Built as hands-on preparation for the **DP-600: Implementing Analytics Solutions Using Microsoft Fabric** certification.

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
| Modeling | Semantic Model (Direct Lake), DAX |
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

## 📊 Dashboard Pages

✅ Executive Dashboard  ✅ Sales Analysis  ✅ Customer Analysis  ✅ Product Analysis
✅ Seller Analysis  ✅ Payment Analysis  ✅ Delivery Performance  ✅ Forecast

---

## ⚙️ Automation Pipeline

```
Notebook (Cleaning)
        │
        ▼
Dataflow Gen2 (Gold Staging)
        │
        ▼
Warehouse Refresh
        │
        ▼
Semantic Model Refresh
        │
        ▼
Power BI Report (auto-updated)
```

Scheduled daily at 2:00 AM, with automatic failure notifications via Teams/Outlook.

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

| | |
|---|---|
| **Workspace** | `screenshots/workspace.png` |
| **Lakehouse** | `screenshots/lakehouse.png` |
| **Notebook** | `screenshots/notebook.png` |
| **Dataflow Gen2** | `screenshots/dataflow.png` |
| **Warehouse** | `screenshots/warehouse.png` |
| **Semantic Model** | `screenshots/semantic-model.png` |
| **Pipeline** | `screenshots/pipeline.png` |
| **Executive Dashboard** | `screenshots/executive-dashboard.png` |

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

⭐ If you found this project useful, consider giving it a star.
