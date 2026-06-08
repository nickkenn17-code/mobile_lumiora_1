import pandas as pd
from sqlalchemy import create_engine
import time
import sys

# --- 1. Database Connection ---
db_host = 'postgres' 
db_port = '5432' 
db_user = 'postgres'
db_pass = '123'
db_name = 'lumiora_db'

# Added connect_timeout to prevent infinite hanging if the DB is busy
DB_URL = f"postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}?connect_timeout=10"
engine = create_engine(DB_URL)

def run_pipeline():
    # Added flush=True to force Python to print out to your terminal instantly
    print("🚀 Starting Data Pipeline...", flush=True)
    
    try:
        print("⏳ Extracting Metric 1 (Daily Sales)...", flush=True)
        query_daily_sales = """
        SELECT DATE(created_at) as order_date, SUM(total_amount) as total_sales
        FROM app_order
        WHERE status = 'completed'
        GROUP BY DATE(created_at);
        """
        df_daily_sales = pd.read_sql(query_daily_sales, engine)
        df_daily_sales.to_sql('report_daily_sales', engine, if_exists='replace', index=False)
        print(f"✅ Metric 1 updated. {len(df_daily_sales)} rows processed.", flush=True)

        print("⏳ Extracting Metrics 2 & 3 (Item Sales)...", flush=True)
        query_item_sales = """
        SELECT 
            DATE(o.created_at) as order_date,
            m.name as item_name,
            SUM(oi.quantity) as total_quantity_sold,
            SUM(oi.quantity * oi.price) as total_item_sales
        FROM app_order o
        JOIN app_orderitem oi ON o.id = oi.order_id
        JOIN app_menuitem m ON oi.menu_item_id = m.id
        WHERE o.status = 'completed'
        GROUP BY DATE(o.created_at), m.name;
        """
        df_item_sales = pd.read_sql(query_item_sales, engine)
        df_item_sales.to_sql('report_daily_item_sales', engine, if_exists='replace', index=False)
        print(f"✅ Metrics 2 & 3 updated. {len(df_item_sales)} rows processed.", flush=True)

        print("⏳ Extracting Metric 4 (Hourly Orders)...", flush=True)
        query_hourly_orders = """
        SELECT 
            DATE(o.created_at) as order_date,
            EXTRACT(HOUR FROM o.created_at) as hour_of_day,
            SUM(oi.quantity) as total_quantity_ordered
        FROM app_order o
        JOIN app_orderitem oi ON o.id = oi.order_id
        WHERE o.status = 'completed'
        GROUP BY DATE(o.created_at), EXTRACT(HOUR FROM o.created_at);
        """
        df_hourly_orders = pd.read_sql(query_hourly_orders, engine)
        df_hourly_orders.to_sql('report_hourly_orders', engine, if_exists='replace', index=False)
        print(f"✅ Metric 4 updated. {len(df_hourly_orders)} rows processed.", flush=True)

        print("🎉 All pipeline tasks finished successfully!", flush=True)

    except Exception as e:
        print(f"❌ Pipeline Error: {e}", flush=True)
        sys.exit(1)

if __name__ == "__main__":
    run_pipeline()