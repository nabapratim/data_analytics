# =====================================================
# PostgreSQL DW Loader (Python)
# - Creates schema & tables
# - NO constraints
# - NO indexes
# - Loads CSV (Excel-exported CSV is fine)
# DB: datawarehouseanalytics
# =====================================================

import psycopg2
from pathlib import Path

# -----------------------------------------------------
# CONFIG
# -----------------------------------------------------
DB_CONFIG = {
    "host": "localhost",
    "database": "data_warehouse_analytics",
    "user": "postgres",
    "password": "password", # replace with your password
    "port": 5432
}

BASE_DIR = Path(__file__).resolve().parent

CSV_FILES = {
    "customers": BASE_DIR /"dataset" / "dim_customers.csv", # replace with your path
    "products":  BASE_DIR / "dataset" / "dim_products.csv",
    "sales":     BASE_DIR / "dataset" / "fact_sales.csv"
}

# -----------------------------------------------------
# CONNECT
# -----------------------------------------------------
conn = psycopg2.connect(**DB_CONFIG)
cur = conn.cursor()

# -----------------------------------------------------
# SCHEMA
# -----------------------------------------------------
cur.execute("""
DROP SCHEMA IF EXISTS gold CASCADE;
CREATE SCHEMA gold;
""")

# -----------------------------------------------------
# TABLES (NO FK / NO INDEX)
# -----------------------------------------------------
cur.execute("""
CREATE TABLE gold.dim_customers (
    customer_key     INT,
    customer_id      INT,
    customer_number  VARCHAR(50),
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    country          VARCHAR(50),
    marital_status   VARCHAR(50),
    gender           VARCHAR(50),
    birthdate        DATE,
    create_date      DATE
);
""")

cur.execute("""
CREATE TABLE gold.dim_products (
    product_key     INT,
    product_id      INT,
    product_number  VARCHAR(50),
    product_name    VARCHAR(50),
    category_id     VARCHAR(50),
    category        VARCHAR(50),
    subcategory     VARCHAR(50),
    maintenance     VARCHAR(50),
    cost            INT,
    product_line    VARCHAR(50),
    start_date      DATE
);
""")

cur.execute("""
CREATE TABLE gold.fact_sales (
    order_number   VARCHAR(50),
    product_key    INT,
    customer_key   INT,
    order_date     DATE,
    shipping_date  DATE,
    due_date       DATE,
    sales_amount   NUMERIC(18,2),
    quantity       INT,
    price          NUMERIC(18,2)
);
""")

# -----------------------------------------------------
# LOAD CSVs (Excel CSV supported)
# COPY FROM STDIN = no permission issues
# -----------------------------------------------------
with open(CSV_FILES["customers"], "r", encoding="utf-8") as f:
    cur.copy_expert(
        "COPY gold.dim_customers FROM STDIN WITH CSV HEADER",
        f
    )

with open(CSV_FILES["products"], "r", encoding="utf-8") as f:
    cur.copy_expert(
        "COPY gold.dim_products FROM STDIN WITH CSV HEADER",
        f
    )

with open(CSV_FILES["sales"], "r", encoding="utf-8") as f:
    cur.copy_expert(
        "COPY gold.fact_sales FROM STDIN WITH CSV HEADER",
        f
    )

# -----------------------------------------------------
# COMMIT & CLOSE
# -----------------------------------------------------
conn.commit()
cur.close()
conn.close()

print("✅ Data warehouse loaded successfully")
