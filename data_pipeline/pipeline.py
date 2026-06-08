import pandas as pd
from sqlalchemy import create_engine
import time
import schedule

# Hardcoded credentials pointing directly to your GCP VM
db_host = 'postgres'
db_port = '5432' 
# The external port mapped in your docker-compose.yml
db_user = 'postgres'
db_pass = '123'
db_name = 'lumiora_db'

# Database connection string
DB_URL = f"postgresql://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}"
engine = create_engine(DB_URL)

def run_pipeline():
    print(f"🚀 Starting Data Pipeline... Connecting to VM at {db_host}")
    try:
        # 1. Total Sales per Day
        query_sales = """
        SELECT DATE(created_at) as order_date, SUM(total_amount) as total_sales
        FROM app_order
        WHERE status = 'completed'
        GROUP BY DATE(created_at);
        """
        df_sales = pd.read_sql(query_sales, engine)
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

        print("✅ Pipeline finished. Summary tables updated in the VM Database!")
    except Exception as e:
        print(f"❌ Pipeline Error: {e}")

# Run it once immediately when the script starts
run_pipeline()

# Schedule it to run every day at midnight automatically
schedule.every().day.at("00:00").do(run_pipeline)

print("⏳ Pipeline Worker is now running and waiting for the next scheduled job...")

# The infinite loop that keeps the container alive
while True:
    schedule.run_pending()
    time.sleep(60) # Wake up every 60 seconds to check the time