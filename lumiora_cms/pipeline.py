import pandas as pd
import os
from sqlalchemy import create_engine, text


db_host = os.getenv('DB_HOST', 'postgres') 
db_user = os.getenv('DB_USER', 'postgres')
db_pass = os.getenv('DB_PASSWORD', '123')
db_name = os.getenv('DB_NAME', 'lumiora_db')

# Database connection string (using your Docker service name 'postgres')
DB_URL = f"postgresql://{db_user}:{db_pass}@{db_host}:5432/{db_name}"
engine = create_engine(DB_URL)

def run_pipeline():
    print("Starting Data Pipeline...")

    # 1. Total Sales per Day
    query_sales = """
    SELECT DATE(created_at) as order_date, SUM(total_amount) as total_sales
    FROM app_order
    WHERE status = 'completed'
    GROUP BY DATE(created_at);
    """
    df_sales = pd.read_sql(query_sales, engine)
    # Save back to a new table for Data Studio
    df_sales.to_sql('report_daily_sales', engine, if_exists='replace', index=False)
    
    # 2. Total Sales per Day per Item
    query_item_sales = """
    SELECT DATE(o.created_at) as order_date, mi.name as item_name, 
           SUM(oi.quantity * oi.price) as total_sales_item
    FROM app_order o
    JOIN app_orderitem oi ON o.id = oi.order_id
    JOIN app_menuitem mi ON oi.menu_item_id = mi.id
    GROUP BY DATE(o.created_at), mi.name;
    """
    df_items = pd.read_sql(query_item_sales, engine)
    df_items.to_sql('report_daily_item_sales', engine, if_exists='replace', index=False)

    print("✅ Pipeline finished. Summary tables updated!")

if __name__ == "__main__":
    run_pipeline()